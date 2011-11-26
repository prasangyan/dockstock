# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111125144703) do

  create_table "authentications", :force => true do |t|
    t.string   "username"
    t.string   "password_salt"
    t.string   "crypted_password"
    t.string   "reset_code"
    t.string   "bucketKey"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "s3_objects", :force => true do |t|
    t.text     "key"
    t.string   "fileName"
    t.string   "parent"
    t.boolean  "folder"
    t.boolean  "rootFolder"
    t.text     "url"
    t.datetime "lastModified"
    t.decimal  "content_length"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
    t.integer  "authentication_id"
    t.string   "parent_uid"
  end

  create_table "s3object_update_queues", :force => true do |t|
    t.string   "bucket_key"
    t.string   "key"
    t.string   "last_modified"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sync_lock", :force => true do |t|
    t.boolean "lock"
  end

  create_table "sync_locks", :force => true do |t|
    t.string   "bucket_key"
    t.boolean  "lock"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
