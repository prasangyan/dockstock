class RemoveTimestamps < ActiveRecord::Migration
  def self.up
    remove_timestamps :s3_objects
    remove_timestamps :s3object_update_queues
    remove_timestamps :sync_locks
    add_column :s3_objects , :sync_time, :datetime
  end

  def self.down
    add_timestamps :s3_objects
    add_timestamps :s3object_update_queues
    add_timestamps :sync_locks
    remove_column :s3_objects , :sync_time, :datetime
  end
end
