class DashboardController < ApplicationController
              before_filter :isuserloggedin
  def index
    #@buckets = AWS::S3::Service.buckets(:reload)
    puts params[:key]
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
  end

  def share
    render :layout => false
  end

end

class SObject
  attr_accessor :name, :content_length,:child,:last_modified,:size , :url, :key
  @name = ""
  @child = ""
  @content_length = 0
  @last_modified = Time.now
  @size = 0
  @url = ""
  @key = ""
  def name=(name)
    @name = name
  end
  def child=(setchild)
    @child = setchild
  end
  def content_length=(content_length)
    @content_length = content_length
  end
  def last_modified=(last_modified)
    @last_modified = last_modified
  end
  def size=(size)
    @size = size
  end
  def url=(url)
    @url = url
  end
  def key=(key)
    @key = key
  end
end