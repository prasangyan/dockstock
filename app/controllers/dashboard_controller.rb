class DashboardController < ApplicationController
              before_filter :isuserloggedin , :except =>["syncamazon", "notify"]
  def index
    @current_user = Authentication.find(session[:currentuser])
    unless params[:key].nil?
      @s3objects = []
      @s3object = S3Object.order(:folder).reverse_order.find_by_uid_and_authentication_id(params[:key].to_s,session[:currentuser])
      @parent_uid = 0
      @folder = false
      unless @s3object.nil?
        @folder = @s3object.folder
        @parent_uid = @s3object.uid
        if @folder == false
           # loading file version history
          s3 = AWS::S3.new(:access_key_id => AMAZON_CONFIG["access_key_id"],:secret_access_key => AMAZON_CONFIG["secret_access_key"])
          bucket = s3.buckets[@current_user.bucketKey]
          unless bucket.nil?
            @s3objects = bucket.objects[@s3object.key].versions
          end
        else
          @s3objects = S3Object.order(:folder).reverse_order.find_all_by_parent_uid_and_authentication_id(params[:key].to_s,session[:currentuser])
        end
      else
        @s3objects = S3Object.order(:folder).reverse_order.find_all_by_parent_uid_and_authentication_id(params[:key].to_s,session[:currentuser])
      end
      @share_object_name = params[:key]
      @s3objects_root = S3Object.order(:folder).reverse_order.find_all_by_parent_uid_and_authentication_id("0",session[:currentuser])
      return
    else
      # loading shared objects
      @s3_shared_objects = []
    end
    @s3objects = S3Object.order(:folder).reverse_order.find_all_by_parent_uid_and_authentication_id("0",session[:currentuser])
    @s3objects_root = @s3objects
    @folder = true
    @parent_uid = 0
    @share_object_name = ''
  end

  def auto_complete
    unless params[:key].nil?
       # right now sending manual values to check ui
       render :json =>  { :folders =>  ["folder1","folder2"], :files => ["file1", "file2"]}
    else
      render :json => {:error => "invalid parameters passed."}
    end
  end

  def syncamazon
    system "rake syncamazon --trace"
    render :text => "done"
  end

  def search
    @s3objects = []
    unless params[:key].nil?
      rsolr = RSolr.connect :url => ENV["WEBSOLR_URL"]
      search = rsolr.select :params => {:q => params[:key].to_s, :defType => "dismax",  :qf => "pdf_texts"}
      puts search['response']['docs']
      search['response']['docs'].each do |doc_id|
        if doc_id["id"].to_s.strip != ''
          s3_object = S3Object.find_by_id(doc_id["id"])
          unless s3_object.nil?
            @s3objects.push(s3_object)
          end
        end
      end
      S3Object.where("upper(key) LIKE '%#{params[:key].to_s.upcase}%'").each do |object|
        unless @s3objects.include?(object)
          @s3objects.push(object)
        end
      end
    end
    @current_user = Authentication.find(session[:currentuser])
    @s3objects_root = S3Object.find_all_by_parent_uid_and_authentication_id("0",session[:currentuser])
    @folder = true
    @parent_uid = 0
    @share_object_name = ''
  end

  def notify
    unless params[:sender_email].nil?
      notification = Notification.new
      notification.email = params[:sender_email]
      if notification.save
      end
      render :text => "success"
    else
      render :text => "invalid parameters passed."
    end
  end

end

