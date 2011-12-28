class ModifyTimeTrackingColumn < ActiveRecord::Migration
  def self.up
    change_column :object_time_trackings , :last_modified, :string
  end

  def self.down
  end
end
