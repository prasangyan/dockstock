class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :name
      t.text :description
      t.integer :project_id
      t.integer :category_id
      t.integer :authentication_id
      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
