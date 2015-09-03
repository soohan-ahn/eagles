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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150903132546) do

  create_table "games", force: :cascade do |t|
    t.string   "home_team",       limit: 255,                         null: false
    t.string   "away_team",       limit: 255,                         null: false
    t.integer  "home_score",      limit: 4,   default: 0,             null: false
    t.integer  "away_score",      limit: 4,   default: 0,             null: false
    t.string   "stadium",         limit: 255
    t.string   "score_box",       limit: 255
    t.string   "league",          limit: 255, default: "Exchibition", null: false
    t.datetime "game_start_time"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.date     "birth"
    t.string   "team",        limit: 255
    t.string   "back_number", limit: 255
    t.string   "bats",        limit: 255
    t.string   "throws",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

end
