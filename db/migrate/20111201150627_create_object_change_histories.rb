class CreateObjectChangeHistories < ActiveRecord::Migration
  def self.up
    create_table :object_change_histories do |t|
      t.integer :machine_id
      t.integer :s3_object_id
      t.integer :s3_object_version_id
    end
  end

  def self.down
    drop_table :object_change_histories
  end
end
