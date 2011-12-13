sync_lock = SyncLock.new
sync_lock.lock=false
sync_lock.save

auth = Authentication.new
auth.username = "santhoshonet@gmail.com"
auth.password="password@123"
auth.bucketKey= "versavault-111201213604"
auth.name = "Santhosh"
unless auth.save
  puts auth.errors
end