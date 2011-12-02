class CreateSharedS3Objects < ActiveRecord::Migration
  def self.up
    create_table :shared_s3_objects do |t|
      t.integer :s3_object_id
      t.integer :authentication_id
    end
    remove_column :s3_objects , :lastModified
  end
  def self.down
    drop_table :shared_s3_objects
    add_column :s3_objects, :lastModified, :string
  end
end
