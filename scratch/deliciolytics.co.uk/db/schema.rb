# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090608195325) do

  create_table "bookmarks", :force => true do |t|
    t.integer  "url_id"
    t.string   "username"
    t.string   "title"
    t.text     "notes"
    t.text     "tags"
    t.datetime "bookmarked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "domain_events", :force => true do |t|
    t.integer  "domain_id"
    t.string   "description"
    t.datetime "started_at"
    t.datetime "finished_at"
  end

  create_table "domains", :force => true do |t|
    t.string   "domain"
    t.string   "domain_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
  end

  create_table "urls", :force => true do |t|
    t.string   "url"
    t.string   "url_hash"
    t.string   "title"
    t.integer  "total_posts"
    t.text     "top_tags"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "domain_id"
  end

end
