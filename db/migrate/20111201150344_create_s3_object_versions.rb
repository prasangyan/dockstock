class CreateS3ObjectVersions < ActiveRecord::Migration
  def self.up
    create_table :s3_object_versions do |t|
      t.datetime :last_modified
      t.string :url
      t.integer :s3_object_id
    end
  end

  def self.down
    drop_table :s3_object_versions
  end
end
