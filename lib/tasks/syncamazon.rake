  desc "This task is to update database with objects in amazon s3"

  task :syncamazon => :environment do
    startsync
  end

  task :update_object, :bucket_key, :key , :last_modified, :needs => :environment  do |t, args|
    puts args[:last_modified]
    auth = Authentication.find_by_bucketKey(args[:bucket_key].to_s)
    unless auth.nil?
      s3 = AWS::S3.new(:access_key_id => "AKIAIW36YM46YELZCT3A",:secret_access_key => "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")
      sync_bucket(s3,auth,args[:key],args[:last_modified])
    end
  end

  private

  def startsync
    s3 = AWS::S3.new(:access_key_id => "AKIAIW36YM46YELZCT3A",:secret_access_key => "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")
    Authentication.all.each do |authentication|

      # destroying all the objects here, right now not used
      #S3Object.find_all_by_authentication_id(authentication.id).each do |object|
      #  object.destroy
      #end

      # getting time to track the deleted objects in the database
      current_Time = Time.parse((Time.now - 60).to_s).getutc

      # lock the user from update his objects from api
      sync_lock = SyncLock.find_by_bucket_key(authentication.bucketKey)
      if sync_lock.nil?
        # may be it is first time so create a record for it
        sync_lock = SyncLock.new
        sync_lock.bucket_key = authentication.bucketKey
        sync_lock.lock=true
        sync_lock.save
      else
        sync_lock.lock = true
        sync_lock.save
      end

      # lets start the sync process
      sync_bucket(s3,authentication,nil,nil)

      # lets destroy the unavailable object record from database
      S3Object.find(:all, :conditions => "sync_time < '#{current_Time}' ").each do |s3object|
        s3object.destroy
      end

      # finally release the lock
      sync_lock.lock= false
      sync_lock.save

    end
    # finally check whether any queue process is pending
    S3objectUpdateQueue.all.each do |s3_object_update_queue|
      auth = Authentication.find_by_bucketKey(s3_object_update_queue.bucket_key)
      unless auth.nil?
          s3_object = S3Object.find_by_authentication_id_and_key(auth.id,s3_object_update_queue.key)
          unless s3_object.nil?
            s3_object.lastModified = DateTime.strptime(s3_object_update_queue.last_modified, "%m/%d/%Y %H:%M:%S %p").to_time
            s3_object.save
          end
          #sync_bucket(s3,auth,s3_object_update_queue.key,s3_object_update_queue.last_modified)
      end
      # finally remove the record
      s3_object_update_queue.destroy
    end
  end

  def sync_bucket(s3,authentication,key,last_modified)
    unless authentication.bucketKey.nil?
      bucket = s3.buckets[authentication.bucketKey]
      unless bucket.nil?
        if key.nil?
          bucket.objects.with_prefix('').each do |object|
            saveobject(object,authentication.id,last_modified)
          end
        else
          bucket.objects.with_prefix(key).each do |object|
            saveobject(object,authentication.id,last_modified)
          end
        end
      else
        bucket = s3.buckets.create(authentication.bucketKey)
      end
    else
      authentication.bucketKey =  "versavault-"  + Time.now.strftime("%y%m%d%H%M%S").to_s
      if authentication.save
        bucket = s3.buckets.create(authentication.bucketKey)
      end
    end
  end

  def saveobject(object,authentication_id,last_modified)
    key = object.key
    if key.to_s[key.length-1] == "/"
      key = key[0..key.length-2]
    end
    s3object = S3Object.find_by_authentication_id_and_key(authentication_id,key)
    if s3object.nil?
      s3object = S3Object.new
      folders = key.to_s.split("/")
      if folders.length == 1
        s3object.rootFolder=true
      else
        s3object.rootFolder=false
      end
      s3object.key = key
      parentfolder = s3object.key.split("/")
      parent_folder = ''
      parentfolder.each_with_index do |fld,idx|
        if object.content_length != "0" && idx == parentfolder.length - 1 && idx != 0
        else
            if parent_folder == ''
              parent_folder = fld.to_s.rstrip
            else
              parent_folder = parent_folder + "/" + fld.to_s.rstrip
            end
        end
      end
      s3object.parent = parent_folder.to_s.rstrip
      s3object.fileName = folders[folders.length - 1]
      s3object.uid = Time.now.strftime("%y%m%d%H%M%S%L")
      s3object.authentication_id = authentication_id
      parent_uid = '0'
      begin
        parent_uid = S3Object.find_by_key_and_authentication_id(parent_folder,authentication_id).uid
      rescue => ex
      end
      s3object.parent_uid = parent_uid
    end
    url = object.url_for(:read,:secure => false)
    s3object.url = url
    unless last_modified.nil?
      s3object.lastModified = DateTime.strptime(last_modified, "%m/%d/%Y %H:%M:%S %p").to_time
    else
      s3object.lastModified = object.last_modified
    end
    if object.content_length.to_s == "0"
      s3object.folder = true
      s3object.content_length = 0
    else
      s3object.content_length = object.content_length
      s3object.folder = false
    end
    s3object.sync_time = Time.now
    unless s3object.save
      puts s3object.errors.full_messages
    end
    S3Object.record_timestamps = true
  end
