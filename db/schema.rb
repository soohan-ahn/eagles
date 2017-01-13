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

ActiveRecord::Schema.define(version: 20170113140310) do

  create_table "at_bat_batter_records", force: :cascade do |t|
    t.integer  "player_id",      limit: 4,                 null: false
    t.integer  "game_id",        limit: 4,                 null: false
    t.integer  "batting_order",  limit: 4,                 null: false
    t.string   "position",       limit: 255, default: "D", null: false
    t.integer  "inning",         limit: 4,                 null: false
    t.integer  "at_plate_order", limit: 4,                 null: false
    t.string   "result_code",    limit: 255,               null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "at_bat_batter_records", ["player_id", "game_id"], name: "index_at_bat_batter_records_on_player_id_and_game_id", using: :btree

  create_table "game_batter_records", force: :cascade do |t|
    t.integer  "player_id",    limit: 4,             null: false
    t.integer  "game_id",      limit: 4,             null: false
    t.integer  "rbi",          limit: 4, default: 0, null: false
    t.integer  "run",          limit: 4, default: 0, null: false
    t.integer  "steal",        limit: 4, default: 0, null: false
    t.integer  "steal_caught", limit: 4, default: 0, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "game_batter_records", ["player_id", "game_id"], name: "index_game_batter_records_on_player_id_and_game_id", unique: true, using: :btree

  create_table "game_fielder_simple_records", force: :cascade do |t|
    t.integer  "player_id",   limit: 4, null: false
    t.integer  "game_id",     limit: 4, null: false
    t.integer  "field_error", limit: 4, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "game_fielder_simple_records", ["player_id", "game_id"], name: "index_game_fielder_simple_records_on_player_id_and_game_id", unique: true, using: :btree

  create_table "game_pitcher_records", force: :cascade do |t|
    t.integer  "player_id",         limit: 4,                 null: false
    t.integer  "game_id",           limit: 4,                 null: false
    t.string   "pitched_order",     limit: 255,               null: false
    t.boolean  "win",               limit: 1
    t.boolean  "lose",              limit: 1
    t.boolean  "save_point",        limit: 1
    t.boolean  "hold",              limit: 1
    t.float    "innings_pitched",   limit: 24,  default: 0.0, null: false
    t.integer  "plate_appearance",  limit: 4,   default: 0,   null: false
    t.integer  "at_bat",            limit: 4,   default: 0,   null: false
    t.integer  "hit",               limit: 4,   default: 0,   null: false
    t.integer  "homerun",           limit: 4,   default: 0,   null: false
    t.integer  "sacrifice_bunt",    limit: 4,   default: 0,   null: false
    t.integer  "sacrifice_fly",     limit: 4,   default: 0,   null: false
    t.integer  "run",               limit: 4,   default: 0,   null: false
    t.integer  "earned_run",        limit: 4,   default: 0,   null: false
    t.integer  "strike_out",        limit: 4,   default: 0,   null: false
    t.integer  "walk",              limit: 4,   default: 0,   null: false
    t.integer  "intentional_walk",  limit: 4,   default: 0,   null: false
    t.integer  "hit_by_pitch",      limit: 4,   default: 0,   null: false
    t.integer  "wild_pitch",        limit: 4,   default: 0,   null: false
    t.integer  "balk",              limit: 4,   default: 0,   null: false
    t.integer  "number_of_pitches", limit: 4,   default: 0,   null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "game_pitcher_records", ["player_id", "game_id"], name: "index_game_pitcher_records_on_player_id_and_game_id", unique: true, using: :btree

  create_table "games", force: :cascade do |t|
    t.string   "home_team",       limit: 255,             null: false
    t.string   "away_team",       limit: 255,             null: false
    t.integer  "home_score",      limit: 4,   default: 0, null: false
    t.integer  "away_score",      limit: 4,   default: 0, null: false
    t.string   "score_box",       limit: 255
    t.datetime "game_start_time"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "league_id",       limit: 4,   default: 1, null: false
    t.integer  "ground_id",       limit: 4,   default: 1, null: false
  end

  add_index "games", ["league_id", "ground_id"], name: "index_games_on_league_id_and_ground_id", using: :btree

  create_table "grounds", force: :cascade do |t|
    t.string   "name",        limit: 255,             null: false
    t.integer  "ground_type", limit: 4,   default: 1, null: false
    t.integer  "grass_type",  limit: 4,   default: 1, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "leagues", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
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

  create_table "season_batter_records", force: :cascade do |t|
    t.integer  "player_id",                             limit: 4,                                         null: false
    t.integer  "year",                                  limit: 4,                                         null: false
    t.integer  "played_game",                           limit: 4,                         default: 0,     null: false
    t.integer  "plate_appearence",                      limit: 4,                         default: 0,     null: false
    t.integer  "at_bat",                                limit: 4,                         default: 0,     null: false
    t.integer  "total_hits",                            limit: 4,                         default: 0,     null: false
    t.integer  "one_base_hit",                          limit: 4,                         default: 0,     null: false
    t.integer  "two_base_hit",                          limit: 4,                         default: 0,     null: false
    t.integer  "three_base_hit",                        limit: 4,                         default: 0,     null: false
    t.integer  "home_run",                              limit: 4,                         default: 0,     null: false
    t.integer  "strike_out",                            limit: 4,                         default: 0,     null: false
    t.integer  "base_on_ball",                          limit: 4,                         default: 0,     null: false
    t.integer  "hit_by_pitched_ball",                   limit: 4,                         default: 0,     null: false
    t.integer  "rbi",                                   limit: 4,                         default: 0,     null: false
    t.integer  "run",                                   limit: 4,                         default: 0,     null: false
    t.integer  "steal",                                 limit: 4,                         default: 0,     null: false
    t.integer  "steal_caught",                          limit: 4,                         default: 0,     null: false
    t.decimal  "batting_average",                                 precision: 4, scale: 3, default: 0.0,   null: false
    t.decimal  "on_base_percentage",                              precision: 4, scale: 3, default: 0.0,   null: false
    t.decimal  "slugging_percentage",                             precision: 4, scale: 3, default: 0.0,   null: false
    t.decimal  "ops",                                             precision: 4, scale: 3, default: 0.0,   null: false
    t.boolean  "is_regular_plate_appearance_satisfied", limit: 1,                         default: false, null: false
    t.integer  "sacrifice_hit",                         limit: 4,                         default: 0,     null: false
    t.integer  "sacrifice_fly",                         limit: 4,                         default: 0,     null: false
    t.integer  "double_play",                           limit: 4,                         default: 0,     null: false
    t.integer  "on_base_by_error",                      limit: 4,                         default: 0,     null: false
    t.datetime "created_at",                                                                              null: false
    t.datetime "updated_at",                                                                              null: false
  end

  add_index "season_batter_records", ["player_id", "year"], name: "index_season_batter_records_on_player_id_and_year", unique: true, using: :btree

  create_table "season_pitcher_records", force: :cascade do |t|
    t.integer  "player_id",                   limit: 4,                                          null: false
    t.integer  "year",                        limit: 4,                                          null: false
    t.integer  "pitched_games",               limit: 4,                          default: 0,     null: false
    t.integer  "win",                         limit: 4,                          default: 0,     null: false
    t.integer  "lose",                        limit: 4,                          default: 0,     null: false
    t.decimal  "era",                                    precision: 4, scale: 2, default: 0.0,   null: false
    t.float    "inning_pitched",              limit: 24,                         default: 0.0,   null: false
    t.integer  "hit",                         limit: 4,                          default: 0,     null: false
    t.integer  "run",                         limit: 4,                          default: 0,     null: false
    t.integer  "earned_run",                  limit: 4,                          default: 0,     null: false
    t.integer  "homerun",                     limit: 4,                          default: 0,     null: false
    t.integer  "walk",                        limit: 4,                          default: 0,     null: false
    t.integer  "strike_out",                  limit: 4,                          default: 0,     null: false
    t.integer  "hit_by_pitch",                limit: 4,                          default: 0,     null: false
    t.decimal  "whip",                                   precision: 4, scale: 2, default: 0.0,   null: false
    t.boolean  "is_regular_inning_satisfied", limit: 1,                          default: false, null: false
    t.datetime "created_at",                                                                     null: false
    t.datetime "updated_at",                                                                     null: false
  end

  add_index "season_pitcher_records", ["player_id", "year"], name: "index_season_pitcher_records_on_player_id_and_year", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string  "email",         limit: 255,                 null: false
    t.string  "password_hash", limit: 255,                 null: false
    t.boolean "is_admin",      limit: 1,   default: false
  end

end
