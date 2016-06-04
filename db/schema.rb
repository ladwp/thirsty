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

ActiveRecord::Schema.define(:version => 20160604210809) do

  create_table "samples", :force => true do |t|
    t.float    "value",      :null => false
    t.integer  "site_id",    :null => false
    t.datetime "sampled_at", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "samples", ["sampled_at", "site_id"], :name => "index_samples_on_sampled_at_and_site_id", :unique => true
  add_index "samples", ["sampled_at"], :name => "index_samples_on_sampled_at"
  add_index "samples", ["site_id"], :name => "index_samples_on_site_id"

  create_table "sites", :force => true do |t|
    t.string   "site_name",        :null => false
    t.string   "measurement_type", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

end
