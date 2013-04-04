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

ActiveRecord::Schema.define(:version => 20130404155143) do

  create_table "identities", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "token"
    t.string   "login_name"
  end

  create_table "issues", :force => true do |t|
    t.text     "content"
    t.string   "title"
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "assignee_id"
    t.text     "relevant_gist", :limit => 255
    t.string   "aasm_state"
    t.string   "gist_id"
  end

  create_table "responses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "issue_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "answer"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "role"
    t.string   "password_digest"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "profile_url"
    t.string   "cell"
    t.boolean  "on_call"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "issue_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
