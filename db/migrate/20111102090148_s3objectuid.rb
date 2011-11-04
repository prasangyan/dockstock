class S3objectuid < ActiveRecord::Migration
  def self.up
    add_column "s3_objects", "uid", :string
    add_column "authentications", "bucketKey", :string
    add_column "s3_objects", "authentication_id", :integer
  end
  def self.down
    remove_column "s3_objects", :uid
    remove_column "authentications", :bucketKey
    remove_column "s3_objects", :authentication_id
  end
end
