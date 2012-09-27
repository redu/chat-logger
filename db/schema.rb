# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20120919170850) do

  create_table "chat_messages", :force => true do |t|
    t.integer  "cmid"
    t.integer  "chat_id"
    t.integer  "user_id"
    t.integer  "contact_id"
    t.text     "message"
    t.datetime "sent_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "chat_messages", ["cmid"], :name => "index_chat_messages_on_cmid"
  add_index "chat_messages", ["contact_id"], :name => "index_chat_messages_on_contact_id"
  add_index "chat_messages", ["user_id"], :name => "index_chat_messages_on_user_id"

  create_table "chats", :force => true do |t|
    t.integer  "cid"
    t.integer  "user_id"
    t.integer  "contact_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "chats", ["cid"], :name => "index_chats_on_cid"
  add_index "chats", ["contact_id"], :name => "index_chats_on_contact_id"
  add_index "chats", ["user_id"], :name => "index_chats_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "spaces", :force => true do |t|
    t.integer  "sid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.integer  "uid"
    t.string   "token"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role_id"
    t.integer  "space_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users", ["token"], :name => "index_users_on_token"
  add_index "users", ["uid"], :name => "index_users_on_uid"
  add_index "users", ["username"], :name => "index_users_on_username"

end
