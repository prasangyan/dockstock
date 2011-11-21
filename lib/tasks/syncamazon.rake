  desc "This task is to update database with objects in amazon s3"

  task :syncamazon => :environment do
    startsync
  end

  task :update_object, :bucket_key, :key , :needs => :environment  do |t, args|
    puts args[:key]
    auth = Authentication.find_by_bucketKey(args[:bucket_key].to_s)
    unless auth.nil?
      s3 = AWS::S3.new(:access_key_id => "AKIAIW36YM46YELZCT3A",:secret_access_key => "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")
      sync_bucket(s3,auth,args[:key])
    end
  end

  private

  def startsync
    s3 = AWS::S3.new(:access_key_id => "AKIAIW36YM46YELZCT3A",:secret_access_key => "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")
    Authentication.all.each do |authentication|
      S3Object.find_all_by_authentication_id(authentication.id).each do |object|
        object.destroy
      end
      sync_bucket(s3,authentication,nil)
    end
  end

  def sync_bucket(s3,authentication,key)
    unless authentication.bucketKey.nil?
      bucket = s3.buckets[authentication.bucketKey]
      unless bucket.nil?
        if key.nil?
          bucket.objects.each do |object|
            saveobject(s3,object,authentication.bucketKey,authentication.id)
          end
        else
          bucket.objects.with_prefix(key).each do |object|
            puts key
            saveobject(s3,object,authentication.bucketKey,authentication.id)
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
  #def sync(s3,key,bucket_id,authentication_id)
    #bucket = AWS::S3::Bucket.find(bucket_id, :prefix => key)
    #bucket = s3.buckets[bucket_id]
    #bucket.objects.with_prefix(key).each do |object|
    #  puts object.key
    #  if object.key != key
    #    saveobject(s3,object,bucket_id,authentication_id)
    #  end
    #end
  #end
  #def savefolders(folders,authentication_id,last_modified,bucket_id,size,url)
  #  path = ''
  #  folders.each_with_index do |fld,idx|
  #    if folders.length == 1 && size != "0"
  #      return
  #    end
  #    if size != "0" && idx == folders.length - 1 && idx != 0
  #      return
  #    end
  #    parent_folder = path
  #    s3obj = S3Object.new
  #    if path == ''
  #      path = path + fld
  #      s3obj.rootFolder=true
  #    else
  #      path = path + "/" + fld
  #      s3obj.rootFolder=false
  #    end
  #    s3obj.key = path
  #    s3obj.lastModified = last_modified
  #    s3obj.url = url #"http://s3.amazonaws.com/" + bucket_id + "/" + path
  #    s3obj.parent = parent_folder
  #    s3obj.fileName = fld
  #    s3obj.folder=true
  #    s3obj.uid = Time.now.strftime("%Y%m%d%H%M%S%L")
  #    s3obj.authentication_id = authentication_id
  #    s3obj.content_length = 0
  #    parent_uid = '0'
  #    begin
  #      parent_uid = S3Object.find_by_key_and_authentication_id(parent_folder,authentication_id).uid
  #    rescue
  #    end
  #    s3obj.parent_uid = parent_uid
  #    s3obj.save
  #    end
  #end
  def saveobject(s3,object,bucket_id,authentication_id)
    s3object = S3Object.new
    key = object.key
    if key.to_s[key.length-1] == "/"
      s3object.key = key[0..key.length-2]
    else
      s3object.key = key
    end
    url = object.url_for(:read)
    folders = key.to_s.split("/")
    if folders.length == 1
      s3object.rootFolder=true
    else
      s3object.rootFolder=false
      #savefolders(folders,authentication_id,object.about["last-modified"],bucket_id,object.about["content-length"].to_s)
      #savefolders(folders,authentication_id,object.last_modified,bucket_id,object.content_length.to_s,url)
    end
    #s3object.lastModified = object.about["last-modified"]
    s3object.lastModified = object.last_modified
    s3object.url = url
    parentfolder = s3object.key.split("/")
    parent_folder = ''
    parentfolder.each_with_index do |fld,idx|
      #if object.about["content-length"] != "0" && idx == parentfolder.length - 1 && idx != 0
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
    #puts s3object.key.to_s  + "-" + object.about["content-length"].to_s
    #if object.about["content-length"].to_s == "0"
    if object.content_length.to_s == "0"
      s3object.folder = true
      s3object.fileName = folders[folders.length - 1]
      s3object.content_length = 0
      #sync(s3,object.key,bucket_id,authentication_id)
    else
      #s3object.content_length = object.about["content-length"]
      s3object.content_length = object.content_length
      s3object.fileName = folders[folders.length - 1]
      s3object.folder = false
    end
    s3object.uid = Time.now.strftime("%Y%m%d%H%M%S%L")
    s3object.authentication_id = authentication_id
    parent_uid = '0'
    begin
      parent_uid = S3Object.find_by_key_and_authentication_id(parent_folder,authentication_id).uid
    rescue => ex
    end
    s3object.parent_uid = parent_uid
    unless s3object.save
      puts s3object.errors.full_messages
      begin
        s3obj = S3Object.find_by_url(s3object.url)
        unless s3obj.nil?
          s3obj.lastModified = s3object.lastModified
          s3obj.save
        end
      end
    end
  end
