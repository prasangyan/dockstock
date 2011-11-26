class CreateS3objectUpdateQueues < ActiveRecord::Migration
  def self.up
    create_table :s3object_update_queues do |t|
      t.string :bucket_key
      t.string :key
      t.string :last_modified
      t.timestamps
    end
    #change_column :s3_objects , :lastModified, :string
  end
  def self.down
    drop_table :s3object_update_queues
    #change_column :s3_objects , :lastModified, :datetime
  end
end
