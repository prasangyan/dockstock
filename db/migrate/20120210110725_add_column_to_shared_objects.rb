class AddColumnToSharedObjects < ActiveRecord::Migration
  def self.up
    add_column :shared_s3_objects, :root_folder, :boolean
  end

  def self.down
    remove_column :shared_s3_objects, :root_folder
  end
end
