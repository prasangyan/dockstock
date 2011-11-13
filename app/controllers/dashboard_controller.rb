class DashboardController < ApplicationController
              before_filter :isuserloggedin , :except => "syncamazon"
  def versions
    s3 = AWS::S3.new(:access_key_id => "AKIAIW36YM46YELZCT3A",:secret_access_key => "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")
     Authentication.all.each do |authentication|
        bucket = s3.buckets[authentication.bucketKey]
        unless bucket.nil?
          bucket.objects.each do |object|
            puts object.versions.count
            object.versions.each do |version|
                puts version.key
            end
          end
        end
     end
    render :text => "done"
  end

  def index
    @current_user = Authentication.find(session[:currentuser])
    unless params[:key].nil?
      @s3objects = []
      @s3object = S3Object.find_by_uid_and_authentication_id(params[:key].to_s,session[:currentuser])
      @parent_uid = 0
      @folder = false
      unless @s3object.nil?
        @folder = @s3object.folder
        @parent_uid = @s3object.uid
      end
      if @folder == false
         # loading file version history
        s3 = AWS::S3.new(:access_key_id => "AKIAIW36YM46YELZCT3A",:secret_access_key => "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")
        bucket = s3.buckets[@current_user.bucketKey]
        unless bucket.nil?
          @s3objects = bucket.objects[@s3object.key].versions
        end
      else
        @s3objects = S3Object.find_all_by_parent_uid_and_authentication_id(params[:key].to_s,session[:currentuser])
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
    system "rake syncamazon"
    render :text => "done"
  end
end

