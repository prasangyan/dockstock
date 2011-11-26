class ApiController < ApplicationController

  def root_files
    unless params[:bucket_key].nil?
      auth = Authentication.find_by_bucketKey(params[:bucket_key])
      unless auth.nil?
        ActiveRecord::Base.include_root_in_json = true
        render :json => S3Object.find_all_by_parent_uid_and_authentication_id("0",auth.id).to_json
      end
    else
      render :json => { :error => "Invalid api key passed." }
    end
  end

  def child_files
    unless params[:bucket_key].nil? and params[:parent_uid].nil?
      auth = Authentication.find_by_bucketKey(params[:bucket_key])
      unless auth.nil?
        ActiveRecord::Base.include_root_in_json = true
        render :json => S3Object.find_all_by_parent_uid_and_authentication_id(params[:parent_uid],auth.id).to_json
      end
    else
      render :json => { :error => "Invalid api key passed." }
    end
  end

  def update_files
    unless params[:bucket_key].nil? and params[:key].nil? and params[:last_modified].nil?
      #sync_lock = SyncLock.find_by_bucket_key(params[:bucket_key].to_s)
      #unless sync_lock.nil?
      #  if sync_lock.lock
          s3object_update_queue = S3objectUpdateQueue.new
          s3object_update_queue.bucket_key = params[:bucket_key].to_s
          s3object_update_queue.key = params[:key].to_s
          s3object_update_queue.last_modified = params[:last_modified].to_s
          s3object_update_queue.save
      #    render :json => {:status => "dashboard view update process postponed."}
      #    return
      #  end
      #end
      #system "rake update_object['#{params[:bucket_key]}','#{params[:key]}','#{params[:last_modified]}'] --trace"
      render :json => {:status => "initiated the task"}
    else
      render :json => {:error => "Invalid key passed."}
    end
  end

  def delete_files
    unless params[:bucket_key].nil? and params[:key].nil?
      auth = Authentication.find_by_bucketKey(params[:bucket_key])
      unless auth.nil?
        s3object = S3Object.find_by_authentication_id_and_key(auth.id,params[:key])
        unless s3object.nil?
          S3Object.find_all_by_parent_uid(s3object.uid).each do |object|
            object.destroy
          end
          s3object.destroy
        end
      end
      render :json => {:status => "removed object successfully"}
    else
      render :json => {:error => "Invalid key passed."}
    end
  end

  #methods for sync tool
  def get_amazon_bucket_id
    unless params[:username].nil? && params[:password].nil?
      result = Authentication.authenticate(params[:username].to_s,params[:password].to_s)
      unless result.nil?
        unless result.bucketKey.nil?
          render :json => {:bucket_id => result.bucketKey}
        else
          result.bucketKey =  "versavault-"  + Time.now.strftime("%y%m%d%H%M%S").to_s
          if result.save
            #AWS::S3::Bucket.create(result.bucketKey,:access => :public_read)
            s3 = AWS::S3.new(:access_key_id => "AKIAIW36YM46YELZCT3A",:secret_access_key => "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")
            bucket = s3.buckets.create(result.bucketKey)
            unless bucket.nil?
              result.save
            end
          end
          render :json => {:bucket_id => result.bucketKey}
        end
      else
        render :json => {:error => "Invalid username or password"}
      end
    else
      render :json => {:error => "Invalid parameters password"}
    end
  end

end
