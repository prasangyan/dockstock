class CreateMachines < ActiveRecord::Migration
  def self.up
    create_table :machines do |t|
      t.string :machine_key
      t.integer :authentication_id
      t.boolean :status
    end
  end

  def self.down
    drop_table :machines
  end
end
