class AddColumnToSharedObjects < ActiveRecord::Migration
  def self.up
    add_column :shared_s3_objects, :root_folder, :boolean
    add_column :shared_s3_objects, :shared_user_auth_id, :integer
  end

  def self.down
    remove_column :shared_s3_objects, :root_folder
    remove_column :shared_s3_objects, :shared_user_auth_id
  end
end
