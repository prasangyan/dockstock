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

  def get_object_status

    unless params[:bucket_key].nil? and params[:key].nil? and params[:machine_key].nil?
      auth = Authentication.find_by_bucketKey(params[:bucket_key])
      unless auth.nil?
        machine = get_machine(params[:machine_key],auth.id)
        ActiveRecord::Base.include_root_in_json = true
        s3objects = {}
        s3objects["S3Object"] = []
        S3Object.find_all_by_key_and_authentication_id(params[:key],auth.id).each do |object|
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
          s3object[:Status] = true
        end
        s3object[:Uid] = object.uid
        s3objects["S3Object"].push (s3object)
      end
      render :json =>  s3objects.to_json
    end

  end

  def add_files

    unless params[:bucket_key].nil? and params[:key].nil? and params[:last_modified].nil? and params[:machine_key].nil?
      authentication = Authentication.find_by_bucketKey(params[:bucket_key])
      unless authentication.nil?
        machine = get_machine(params[:machine_key],authentication.id)
        s3_object = S3Object.find_by_authentication_id_and_key(authentication.id,params[:key])
        unless s3_object.nil?
          add_time_tracking(s3_object.id,machine.id,params[:last_modified])
          render :text => "updated."
          return
        else
          update_amazon_object(authentication.id,params[:bucket_key],params[:key],params[:last_modified],machine.id)
          return
        end
      end
      render :text => "invalid parameters passed."
    else
      render :json => {:error => "Invalid key passed."}
    end

  end

  def update_files

    unless params[:bucket_key].nil? and params[:key].nil? and params[:last_modified].nil? and params[:machine_key].nil?
      authentication = Authentication.find_by_bucketKey(params[:bucket_key])
      unless authentication.nil?
        machine = get_machine(params[:machine_key],authentication.id)
        s3_object = S3Object.find_by_authentication_id_and_key(authentication.id,params[:key])
        unless s3_object.nil?
          update_time_tracking(s3_object.id,machine.id,params[:last_modified])
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
        else
          update_amazon_object(authentication.id, params[:bucket_key],params[:key],params[:last_modified],machine.id)
          return
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
          ObjectTimeTracking.find_all_by_s3_object_id_and_machine_id(s3object.id,machine.id).each do |object_time_track|
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
            s3 = AWS::S3.new(:access_key_id => AMAZON_CONFIG["access_key_id"],:secret_access_key => AMAZON_CONFIG["secret_access_key"])
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

  def update_time_tracking(s3_object_id,machine_id,last_modified)
    add_time_tracking(s3_object_id,machine_id,last_modified)
    ObjectTimeTracking.find_all_by_s3_object_id(s3_object_id).each do |object_time_tracking|
      if object_time_tracking.machine_id != machine_id
        object_time_tracking.last_modified = last_modified
        unless object_time_tracking.save
          puts object_time_tracking.errors.full_messages
        end
      end
    end
  end

  def add_time_tracking(s3_object_id,machine_id,last_modified)

    object_time_on_machine = ObjectTimeTracking.find_by_s3_object_id_and_machine_id(s3_object_id,machine_id)
    if object_time_on_machine.nil?
      object_time_on_machine = ObjectTimeTracking.new
      object_time_on_machine.s3_object_id = s3_object_id
      object_time_on_machine.machine_id = machine_id
      object_time_on_machine.status=true
      object_time_on_machine.last_modified = Time.now.to_s
      object_time_on_machine.save
    end
    object_time_on_machine.last_modified = last_modified
    unless object_time_on_machine.save
      puts object_time_on_machine.errors.full_messages
    end

  end

  def update_amazon_object(authentication_id,bucket_key,key,last_modified,machine_id)

    require "Synchonization"
    sync = Synchronization.new
    sync.sync_object_with_tree(authentication_id,bucket_key,key)

    s3_object = S3Object.find_by_authentication_id_and_key(authentication_id,key)
    unless s3_object.nil?
      update_time_tracking(s3_object.id,machine_id,last_modified)
      render :text => "updated."
    else
      render :text => "key not found"
    end

  end

end
