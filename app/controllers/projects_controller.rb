require "aws/s3"
class ProjectsController < ApplicationController
    before_filter :isuserloggedin
  # GET /projects
  # GET /projects.xml
  def index
    @client_name = params[:id]
    unless @client_name.nil?
      client = Client.find_by_name(@client_name)
      @projects = client.projects
    else
      redirect_to :controller => "clients"
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @client_name = params[:id]
    unless @client_name.nil?
      client = Client.find_by_name(@client_name)
      @project = client.projects.new
    end
    render :layout => false
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new
    @project.name = params[:name]
    @project.description = params[:description]
    @project.client_id = params[:client_id]
#    @deleteproject = Project.find_all_by_name(@project.name)
#    @deleteproject.each do |proj|
#      proj.destroy
#    end
    if @project.save
        flash[:notice] = 'Project was successfully created.'
        if ENV['RAILS_ENV'] != "test"
          # getting the root folder first
          unless exists_in_s3?(@project.name,S3SwfUpload::S3Config.bucket, {:folder => true} )
            create_s3_folder(@project.name,S3SwfUpload::S3Config.bucket,{:folder => true})
          end
        end
        redirect_to "/projectlist/" + @project.client.name
    else

        flash[:notice] = 'Unable to create the project due to ' + @project.errors.full_messages[0].to_s
        redirect_to :controller => "clients"
    end

  end

  def status
  end

  private
  S3_FOLDER_EXT = '/'
  def exists_in_s3?(file_name, bucket_name, options ={})
    connect_to_s3
    file_search_name = file_name.dup
    file_search_name << S3_FOLDER_EXT if options[:folder]
    AWS::S3::Bucket.objects(bucket_name, :prefix => file_search_name).any?
  end

  def create_s3_folder(file_name, bucket_name, options={})
    connect_to_s3
    folder = AWS::S3::S3Object.store(file_name + S3_FOLDER_EXT, '', bucket_name,
      {:access => :public_read,
       :content_type => "binary/octet-stream",
       :cache_control => 'max-age=3600,post-check=900,pre-check=3600' }.update(options))
  end

  def connect_to_s3
    unless AWS::S3::Base.connected?
      AWS::S3::Base.establish_connection!(:access_key_id => S3SwfUpload::S3Config.access_key_id, :secret_access_key => S3SwfUpload::S3Config.secret_access_key)
    end
  end

end
