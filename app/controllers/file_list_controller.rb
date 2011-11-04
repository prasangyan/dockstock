require "aws/s3"
class FileListController < ApplicationController
             before_filter :isuserloggedin
  def index
    unless params[:id].nil?
        @project = params[:id]
        session[:folder_name] = @project
        @proj =  Project.find_by_name(@project)
        @client_name = @proj.client.name
        session[:project_name] = @project
        #@objects = AWS::S3::Bucket.objects(S3SwfUpload::S3Config.bucket, :prefix => @project + "/")
    else
        redirect_to :controller => "dashboard"
    end
  end
  def upload
    render :layout => false
  end
end
