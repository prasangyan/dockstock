class CreateUserSessions < ActiveRecord::Migration
  def self.up
    create_table :user_sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.string :username
      t.string :password
      t.boolean :remember_me
      t.timestamps
    end
    add_index :sessions, :session_id
    add_index :sessions, :updated_at
  end

  def self.down
    drop_table :sessions
  end
end
