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

ActiveRecord::Schema.define(:version => 20110814161941) do

  create_table "attendances", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.string   "state",         :default => "added"
    t.datetime "confirmed_at"
    t.datetime "declined_at"
    t.datetime "waitlisted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "token"
  end

  add_index "attendances", ["event_id"], :name => "index_attendances_on_event_id"
  add_index "attendances", ["user_id"], :name => "index_attendances_on_user_id"

  create_table "authorizations", :force => true do |t|
    t.integer  "user_id"
    t.string   "key"
    t.string   "provider"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorizations", ["user_id"], :name => "index_authorizations_on_user_id"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "start_at"
    t.datetime "end_at"
    t.string   "location"
    t.string   "city"
    t.boolean  "public",            :default => true
    t.boolean  "allow_invites",     :default => true
    t.string   "state",             :default => "created"
    t.integer  "attendee_quota"
    t.integer  "host_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_commented_at"
    t.string   "token"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_url"
    t.boolean  "wants_comment_notifications", :default => true
  end

end
