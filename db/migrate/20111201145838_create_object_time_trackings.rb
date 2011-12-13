class CreateObjectTimeTrackings < ActiveRecord::Migration
  def self.up
    create_table :object_time_trackings do |t|
      t.integer :s3_object_id
      t.string :last_modified
      t.integer :machine_id
      t.boolean :status
    end
  end

  def self.down
    drop_table :object_time_trackings
  end
end
