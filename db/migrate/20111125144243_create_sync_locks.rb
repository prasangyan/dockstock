class CreateSyncLocks < ActiveRecord::Migration
  def self.up
    create_table :sync_locks do |t|
      t.string :bucket_key
      t.boolean :lock
      t.timestamps
    end
  end

  def self.down
    drop_table :sync_locks
  end
end
