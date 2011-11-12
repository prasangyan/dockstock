class DashboardController < ApplicationController
              before_filter :isuserloggedin , :except => "syncamazon"
  def index
    @current_user = Authentication.find(session[:currentuser])
    unless params[:key].nil?
      @s3objects = S3Object.find_all_by_parent_uid_and_authentication_id(params[:key].to_s,session[:currentuser])
      folder = S3Object.find_by_uid_and_authentication_id(params[:key].to_s,session[:currentuser])
      @parent_uid = 0
      unless folder.nil?
        @folder = folder.folder
        @parent_uid = folder.uid
      else
        @folder = false
      end
      @share_object_name = params[:key]
      @s3objects_root = S3Object.find_all_by_parent_uid_and_authentication_id("0",session[:currentuser])
      return
    end
    @s3objects = S3Object.find_all_by_parent_uid_and_authentication_id("0",session[:currentuser])
    @s3objects_root = @s3objects
    @folder = true
    @parent_uid = 0
    @share_object_name = ''
=begin
    #@buckets = AWS::S3::Service.buckets(:reload)
    values = {}
    @sobjects = Array.new
    @bucket = AWS::S3::Bucket.find(S3SwfUpload::S3Config.bucket, :prefix => params[:key])
    @bucket.objects.each do |object|
      s3obj = SObject.new
      s3obj.key = object.key.to_s.sub("/","?")
      uri = URI.parse(object.url)
      uri.query = nil
      s3obj.url = uri.to_s
      folders = object.key.split('/')
      if folders.length > 1
        #count = AWS::S3::Bucket.objects(S3SwfUpload::S3Config.bucket, :prefix => folders[0] + "/").size
        #@folders["#{folders[0]}"] =  count - 1
        unless values.include?(folders[0])
          values[folders[0]] = ""
          s3obj.name = folders[0]
          s3obj.child = folders[1]
          s3obj.content_length= object.about["content-length"]
          s3obj.last_modified = object.about["last-modified"]
          if s3obj.content_length.to_i == 0
            AWS::S3::Bucket.find(S3SwfUpload::S3Config.bucket, :prefix => object.key).each do |obj|
              folders = obj.key.split('/')
              if folders.length == 2 and obj.content_length != "0"
                  s3obj.size = s3obj.size.to_i + 1
              end
            end
          end
          @sobjects.push(s3obj)
        end
      else
        unless values.include?(folders[0])
          values[folders[0]] = ""
          s3obj.name = folders[0]
          s3obj.child = nil
          s3obj.content_length= object.about["content-length"]
          s3obj.last_modified = object.about["last-modified"]
          if s3obj.content_length.to_i == 0
            AWS::S3::Bucket.find(S3SwfUpload::S3Config.bucket, :prefix => object.key).each do |obj|
              folders = obj.key.split('/')
              if folders.length == 2 and obj.content_length != "0"
                s3obj.size = s3obj.size.to_i + 1
              end
            end
          end
          @sobjects.push(s3obj)
        end
      end
    end
=end

  end

  def share
    render :layout => false
  end

  def syncamazon
    Authentication.all.each do |authentication|
      unless authentication.bucketKey.nil?
        begin
          bucket = AWS::S3::Bucket.find(authentication.bucketKey)
          unless bucket.nil?
            bucket.objects.each do |object|
              saveobject(object,authentication.bucketKey,authentication.id)
            end
          end
        rescue => ex
          puts ex.message
          if ex.message == "The specified bucket does not exist"
            AWS::S3::Bucket.create(authentication.bucketKey,:access => :public_read)
          end
        end
      else
        authentication.bucketKey = authentication.name + "-"  + Time.now.strftime("%y%m%d%H%M%S").to_s
        if authentication.save
          AWS::S3::Bucket.create(authentication.bucketKey,:access => :public_read)
        end
      end
    end
    render :text => "done"
  end

  private

  def sync(key,bucket_id,authentication_id)
    bucket = AWS::S3::Bucket.find(bucket_id, :prefix => key)
    bucket.objects.each do |object|
      if object.key != key
        saveobject(object,bucket_id,authentication_id)
      end
    end
  end

  def savefolders(folders,authentication_id,last_modified,bucket_id,size)
    path = ''
    folders.each_with_index do |fld,idx|
      if folders.length == 1 && size != "0"
        return
      end
      if size != "0" && idx == folders.length - 1 && idx != 0
        return
      end
      parent_folder = path
      s3obj = S3Object.new
      if path == ''
        path = path + fld
        s3obj.rootFolder=true
      else
        path = path + "/" + fld
        s3obj.rootFolder=false
      end
      s3obj.key = path
      s3obj.lastModified = last_modified
      s3obj.url = "http://s3.amazonaws.com/" + bucket_id + "/" + path
      s3obj.parent = parent_folder
      s3obj.fileName = fld
      s3obj.folder=true
      s3obj.uid = Time.now.strftime("%Y%m%d%H%M%S%L")
      s3obj.authentication_id = authentication_id
      s3obj.content_length = 0
      parent_uid = '0'
      begin
        parent_uid = S3Object.find_by_key_and_authentication_id(parent_folder,authentication_id).uid
      rescue
      end
      s3obj.parent_uid = parent_uid
      s3obj.save
      end
  end

  def saveobject(object,bucket_id,authentication_id)
    uri = URI.parse(object.url)
    uri.query = nil
    s3object = S3Object.new
    if object.key.to_s[object.key.length-1] == "/"
      s3object.key = object.key[0..object.key.length-2]
    else
      s3object.key = object.key
    end
    folders = s3object.key.to_s.split("/")
    if folders.length == 1
      s3object.rootFolder=true
    else
      s3object.rootFolder=false
      savefolders(folders,authentication_id,object.about["last-modified"],bucket_id,object.about["content-length"].to_s)
    end
    s3object.lastModified = object.about["last-modified"]
    if uri.to_s[uri.to_s.length-1] == "/"
      s3object.url = uri.to_s[0..uri.to_s.length-2]
    else
      s3object.url = uri.to_s
    end
    parentfolder =s3object.key.split("/")
    parent_folder = ''
    parentfolder.each_with_index do |fld,idx|
      if object.about["content-length"] != "0" && idx == parentfolder.length - 1 && idx != 0
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
    if object.about["content-length"].to_s == "0"
      s3object.folder = true
      s3object.fileName = folders[folders.length - 1]
      s3object.content_length = 0
      sync(object.key,bucket_id,authentication_id)
    else
      s3object.content_length = object.about["content-length"]
      s3object.fileName = folders[folders.length - 1]
      s3object.folder = false
    end
    s3object.uid = Time.now.strftime("%Y%m%d%H%M%S%L")
    s3object.authentication_id = authentication_id
    parent_uid = '0'
    begin
      parent_uid = S3Object.find_by_key_and_authentication_id(parent_folder,authentication_id).uid
    rescue => ex
      puts ex.message
    end
    s3object.parent_uid = parent_uid
    s3object.save
  end

end

