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
    unless params[:bucket_key].nil? and params[:parent_key].nil?
      auth = Authentication.find_by_bucketKey(params[:bucket_key])
      unless auth.nil?
        ActiveRecord::Base.include_root_in_json = true
        render :json => S3Object.find_all_by_parent_uid_and_authentication_id("0",auth.id).to_json
      end
    else
      render :json => { :error => "Invalid api key passed." }
    end
  end

end
