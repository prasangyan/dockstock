class DashboardController < ApplicationController
              before_filter :isuserloggedin
  def index
    #@buckets = AWS::S3::Service.buckets(:reload)
    @folders = Hash.new
    @bucket = AWS::S3::Bucket.find(S3SwfUpload::S3Config.bucket)
    @bucket.objects.each do |object|
      folders = object.key.split('/')
      if folders.length > 0
        count = AWS::S3::Bucket.objects(S3SwfUpload::S3Config.bucket, :prefix => folders[0] + "/").size
        @folders["#{folders[0]}"] =  count - 1
      end
    end
  end
end
