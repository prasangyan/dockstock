  desc "This task is to update database with objects in amazon s3"
  task :syncamazon => :environment do
    require "Synchonization"
    sync = Synchronization.new
    sync.startsync
  end

  task :update_object, :bucket_key, :key , :last_modified, :needs => :environment  do |t, args|
    auth = Authentication.find_by_bucketKey(args[:bucket_key].to_s)
    unless auth.nil?
      s3 = AWS::S3.new(:access_key_id => "AKIAIW36YM46YELZCT3A",:secret_access_key => "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")
      require "Synchonization"
      sync = Synchronization.new
      sync.sync_bucket(s3,auth,args[:key])
    end
  end


