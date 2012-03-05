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

ActiveRecord::Schema.define(:version => 20120210110725) do

  create_table "authentications", :force => true do |t|
    t.string   "username"
    t.string   "password_salt"
    t.string   "crypted_password"
    t.string   "reset_code"
    t.string   "bucketKey"
    t.string   "name"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "machines", :force => true do |t|
    t.string   "machine_key"
    t.integer  "authentication_id"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "object_change_histories", :force => true do |t|
    t.integer  "machine_id"
    t.integer  "s3_object_id"
    t.integer  "s3_object_version_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "object_time_trackings", :force => true do |t|
    t.integer  "s3_object_id"
    t.string   "last_modified"
    t.integer  "machine_id"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "s3_object_versions", :force => true do |t|
    t.datetime "last_modified"
    t.string   "url"
    t.integer  "s3_object_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "s3_objects", :force => true do |t|
    t.text     "key"
    t.string   "fileName"
    t.string   "parent"
    t.boolean  "folder"
    t.boolean  "rootFolder"
    t.text     "url"
    t.decimal  "content_length"
    t.string   "uid"
    t.integer  "authentication_id"
    t.string   "parent_uid"
    t.datetime "sync_time"
  end

  create_table "s3object_update_queues", :force => true do |t|
    t.string "bucket_key"
    t.string "key"
    t.string "last_modified"
  end

  create_table "shared_s3_objects", :force => true do |t|
    t.integer  "s3_object_id"
    t.integer  "authentication_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "root_folder"
    t.integer  "shared_user_auth_id"
  end

  create_table "sync_locks", :force => true do |t|
    t.string  "bucket_key"
    t.boolean "lock"
  end

  create_table "user_sessions", :force => true do |t|
    t.string   "session_id",  :null => false
    t.text     "data"
    t.string   "username"
    t.string   "password"
    t.boolean  "remember_me"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
