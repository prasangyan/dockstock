class ApiController < ApplicationController

  def root_files
    unless params[:bucket_key].nil? and params[:machine_key].nil?
      get_s3_objects("0",params[:bucket_key],params[:machine_key])
    else
      render :json => { :error => "Invalid api key passed." }
    end
  end

  def child_files
    unless params[:bucket_key].nil? and params[:parent_uid].nil? and params[:machine_key].nil?
      get_s3_objects(params[:parent_uid],params[:bucket_key],params[:machine_key])
    else
      render :json => { :error => "Invalid api key passed." }
    end
  end

  def get_s3_objects(parent_uid,bucket_key,machine_key)
    auth = Authentication.find_by_bucketKey(bucket_key)
    unless auth.nil?
      machine = get_machine(machine_key,auth.id)
      ActiveRecord::Base.include_root_in_json = true
      s3objects = {}
      s3objects["S3Object"] = []
      S3Object.find_all_by_parent_uid_and_authentication_id(parent_uid,auth.id).each do |object|
        s3object = {}
        s3object[:FileName] = object.fileName
        s3object[:Folder] = object.folder
        s3object[:Key] = object.key
        object_time = ObjectTimeTracking.find_by_s3_object_id_and_machine_id(object.id,machine.id)
        unless object_time.nil?
          s3object[:LastModified] =  object_time.last_modified
          s3object[:Status] = object_time.status
        else
          s3object[:LastModified] = DateTime.parse("2000-01-01")
        end
        s3object[:Uid] = object.uid
        s3objects["S3Object"].push (s3object)
      end
      render :json =>  s3objects.to_json
    end
  end

  def update_files
    unless params[:bucket_key].nil? and params[:key].nil? and params[:last_modified].nil? and params[:machine_key].nil?
      authentication = Authentication.find_by_bucketKey(params[:bucket_key])
      unless authentication.nil?
        machine = get_machine(params[:machine_key],authentication.id)
        s3_object = S3Object.find_by_authentication_id_and_key(authentication.id,params[:key])
        unless s3_object.nil?
          object_time_on_machine = ObjectTimeTracking.find_by_s3_object_id_and_machine_id(s3_object.id,machine.id)
          if object_time_on_machine.nil?
            object_time_on_machine = ObjectTimeTracking.new
            object_time_on_machine.s3_object_id = s3_object.id
            object_time_on_machine.machine_id = machine.id
            object_time_on_machine.status=true
            object_time_on_machine.last_modified = Time.now.to_s
            object_time_on_machine.save
          end
          object_time_on_machine.last_modified = params[:last_modified]
          object_time_on_machine.save
          render :text => "updated."
          return
          #sync_lock = SyncLock.find_by_bucket_key(params[:bucket_key].to_s)
          #unless sync_lock.nil?
          #  if sync_lock.lock
          #    s3object_update_queue = S3objectUpdateQueue.new
          #    s3object_update_queue.bucket_key = params[:bucket_key].to_s
          #    s3object_update_queue.key = params[:key].to_s
          #    s3object_update_queue.last_modified = params[:last_modified].to_s
          #    s3object_update_queue.save
          #    render :json => {:status => "dashboard view update process postponed."}
          #    return
          #  end
          #end
          #system "rake update_object['#{params[:bucket_key]}','#{params[:key]}','#{params[:last_modified]}'] --trace"
        end
      end
      render :text => "invalid parameters passed."
      #render :json => {:status => "initiated the task"}
    else
      render :json => {:error => "Invalid key passed."}
    end
  end

  def delete_files
    unless params[:bucket_key].nil? and params[:key].nil? and params[:machine_key].nil?
      auth = Authentication.find_by_bucketKey(params[:bucket_key])
      unless auth.nil?
        s3object = S3Object.find_by_authentication_id_and_key(auth.id,params[:key])
        unless s3object.nil?
          ObjectTimeTracking.find_all_by_s3_object_id_and_machine_id(s3_object.id,machine.id).each do |object_time_track|
            object_time_track.status = false
            object_time_track.save
          end
          S3Object.find_all_by_parent_uid(s3object.uid).each do |object|
            ObjectTimeTracking.find_all_by_s3_object_id_and_machine_id(object.id,machine.id).each do |object_time_track|
              object_time_track.status = false
              object_time_track.save
            end
            object.destroy
          end
          s3object.destroy
        end
      end
      render :json => {:status => "removed object successfully."}
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
          render :json => {:BucketId => result.bucketKey}
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
          render :json => {:BucketId => result.bucketKey}
        end
      else
        render :json => {:Error => "Invalid username or password."}
      end
    else
      render :json => {:Error => "Invalid parameters password."}
    end
  end

  private

  def get_machine(machine_key,authentication_id)
    machine = Machine.find_by_machine_key_and_authentication_id(machine_key,authentication_id)
    if machine.nil?
      machine = Machine.new
      machine.machine_key = machine_key
      machine.authentication_id = authentication_id
      machine.status=true
      machine.save
    end
    return machine
  end

end
