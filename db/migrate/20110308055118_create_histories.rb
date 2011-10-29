class CreateHistories < ActiveRecord::Migration
  def self.up
    create_table :histories do |t|
      t.text :description
      t.integer :document_id
      t.integer :authentication_id
      t.timestamps
    end
  end

  def self.down
    drop_table :histories
  end
end
