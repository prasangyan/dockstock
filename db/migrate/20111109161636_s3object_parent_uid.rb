class S3objectParentUid < ActiveRecord::Migration
  def self.up
     add_column "s3_objects", "parent_uid", :string
  end

  def self.down
    remove_column "s3_objects", :parent_uid
  end
end
