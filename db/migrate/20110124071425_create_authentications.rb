class CreateAuthentications < ActiveRecord::Migration
  def self.up
    create_table :authentications do |t|
      t.string :username
      t.string :password_salt
      t.string :crypted_password
      t.string :reset_code, :default => ""
      t.string :persistence_token
      t.timestamps
    end
  end

  def self.down
    drop_table :authentications
  end
end
