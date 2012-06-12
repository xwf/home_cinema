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

ActiveRecord::Schema.define(:version => 20120611101805) do

  create_table "movie_suggestions", :force => true do |t|
    t.integer  "movie_id",        :null => false
    t.integer  "show_id",         :null => false
    t.integer  "registration_id"
    t.text     "comment"
    t.string   "status"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "movies", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "length"
    t.integer  "year"
    t.string   "image_url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "registrations", :force => true do |t|
    t.string   "code",       :limit => 4, :null => false
    t.string   "name"
    t.string   "email"
    t.string   "status"
    t.integer  "show_id",                 :null => false
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "seat_reservations", :force => true do |t|
    t.integer  "registration_id"
    t.integer  "seat_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "seats", :force => true do |t|
    t.string   "name"
    t.string   "image_path_free"
    t.string   "image_path_selected"
    t.string   "image_path_taken"
    t.decimal  "position_x",          :precision => 8, :scale => 3
    t.decimal  "position_y",          :precision => 8, :scale => 3
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  create_table "shows", :force => true do |t|
    t.datetime "date"
    t.text     "text"
    t.boolean  "movie_suggestions_allowed", :default => true
    t.integer  "featured_movie_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "votes", :force => true do |t|
    t.integer  "movie_suggestion_id",                :null => false
    t.integer  "registration_id",                    :null => false
    t.integer  "points",              :default => 0, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

end
