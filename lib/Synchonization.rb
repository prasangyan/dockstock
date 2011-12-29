class Synchronization

  attr_accessor :startsync
  attr_accessor :sync_bucket
  attr_accessor :saveobject
  attr_accessor :sync_object_with_tree
  attr_accessor :sync_objects_folder

  def startsync
    begin
      s3 = AWS::S3.new(:access_key_id => AMAZON_CONFIG["access_key_id"],:secret_access_key => AMAZON_CONFIG["secret_access_key"])
      Authentication.all.each do |authentication|
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
        sync_bucket(s3,authentication,nil)
        #   lets destroy the unavailable object record from database
        S3Object.find(:all, :conditions => "sync_time < '#{current_Time}' and authentication_id = #{authentication.id} ").each do |s3object|
          s3object.destroy
        end
        # finally release the lock
        sync_lock.lock= false
        sync_lock.save
      end
    rescue => ex
      puts "Error at synchronization due to " + ex.message
    end
    ObjectTimeTracking.all.each do |object_time_tracking|
      begin
        s3_object = S3Object.find(object_time_tracking.s3_object_id)
        if s3_object.nil?
          object_time_tracking.destroy
        end
      rescue
      end
    end
=begin
    # finally check whether any queue process is pending
    S3objectUpdateQueue.all.each do |s3_object_update_queue|
      auth = Authentication.find_by_bucketKey(s3_object_update_queue.bucket_key)
      unless auth.nil?
          s3_object = S3Object.find_by_authentication_id_and_key(auth.id,s3_object_update_queue.key)
          unless s3_object.nil?
            s3_object.lastModified = DateTime.strptime(s3_object_update_queue.last_modified, "%m/%d/%Y %H:%M:%S %p").to_time
            s3_object.save
          end
      end
      # finally remove the record
      s3_object_update_queue.destroy
    end
=end

  end

  def sync_bucket(s3,authentication,key)
    unless authentication.bucketKey.nil?
      bucket = s3.buckets[authentication.bucketKey]
      unless bucket.nil?
        if key.nil?
          begin
            bucket.objects.with_prefix('').each do |object|
              saveobject(object,authentication.id)
            end
          rescue => ex
            puts ex.message
          end
        else
          bucket.objects.with_prefix(key).each do |object|
            saveobject(object,authentication.id)
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

  def saveobject(object,authentication_id)
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
      if parentfolder.length > 1
        if parentfolder[1].strip != ""
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
    if object.key.to_s[object.key.length-1] == "/" #if object.content_length.to_s == "0"
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
  end

  def sync_object_with_tree(authentication_id,bucket_key,key)
    auth = Authentication.find(authentication_id)
    unless auth.nil?
      s3 = AWS::S3.new(:access_key_id => AMAZON_CONFIG["access_key_id"],:secret_access_key => AMAZON_CONFIG["secret_access_key"])
      bucket = s3.buckets[bucket_key]
      unless bucket.nil?
        tree = bucket.as_tree(:prefix => key, :delimiter => "/")
        if tree.parent.nil?
          tree.collection.each do |object|
            if key.to_s.downcase == object.key.to_s.downcase or key.to_s.downcase + "/" == object.key.to_s.downcase
              saveobject(object,authentication_id)
            end
          end
        else
          root_node = tree.parent
          while !root_node.parent.nil?
            root_node = root_node.parent
          end
          sync_objects_folder(root_node,authentication_id)
        end
      end
    end
  end

  def sync_objects_folder(node,authentication_id)
    node.children.select(&:leaf?).each do |object|
      saveobject(object,authentication_id)
    end
    node.children.select(&:branch?).each do |object|
      sync_objects_folder(object,authentication_id)
    end
  end

end

