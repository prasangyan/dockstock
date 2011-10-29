class CreateS3Objects < ActiveRecord::Migration
  def self.up
    create_table :s3_objects do |t|
      t.text :key
      t.string :fileName
      t.string :parent
      t.boolean :folder
      t.boolean :rootFolder
      t.text  :url
      t.datetime :lastModified
      t.decimal :content_length
      t.timestamps
    end
  end
  def self.down
    drop_table :s3_objects
  end
end
