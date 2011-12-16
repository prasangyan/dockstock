  desc "This task is to update database with objects in amazon s3"
  task :syncamazon => :environment do
    require "Synchonization"
    sync = Synchronization.new
    sync.startsync
  end

  task :update_object, :bucket_key, :key , :last_modified, :needs => :environment  do |t, args|
    auth = Authentication.find_by_bucketKey(args[:bucket_key].to_s)
    unless auth.nil?
      s3 = AWS::S3.new(:access_key_id => AMAZON_CONFIG["access_key_id"],:secret_access_key => AMAZON_CONFIG["secret_access_key"])
      require "Synchonization"
      sync = Synchronization.new
      sync.sync_bucket(s3,auth,args[:key])
    end
  end


