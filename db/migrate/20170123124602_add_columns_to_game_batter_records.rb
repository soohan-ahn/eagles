class AddColumnsToGameBatterRecords < ActiveRecord::Migration
  def up
    add_column :game_batter_records, :plate_appearence, :integer, null:false, default: 0, after: :game_id
    add_column :game_batter_records, :at_bat, :integer, null:false, default: 0, after: :plate_appearence
    add_column :game_batter_records, :total_hits, :integer, null:false, default: 0, after: :at_bat
    add_column :game_batter_records, :one_base_hit, :integer, null:false, default: 0, after: :total_hits
    add_column :game_batter_records, :two_base_hit, :integer, null:false, default: 0, after: :one_base_hit
    add_column :game_batter_records, :three_base_hit, :integer, null:false, default: 0, after: :two_base_hit
    add_column :game_batter_records, :home_run, :integer, null:false, default: 0, after: :three_base_hit
    add_column :game_batter_records, :strike_out, :integer, null:false, default: 0, after: :home_run
    add_column :game_batter_records, :base_on_ball, :integer, null:false, default: 0, after: :strike_out
    add_column :game_batter_records, :hit_by_pitched_ball, :integer, null:false, default: 0, after: :base_on_ball
    add_column :game_batter_records, :sacrifice_hit, :integer,  limit: 4,  default: 0, null: false, after: :steal_caught
    add_column :game_batter_records, :sacrifice_fly, :integer, limit: 4,  default: 0, null: false, after: :sacrifice_hit
    add_column :game_batter_records, :double_play, :integer, limit: 4,  default: 0,  null: false, after: :sacrifice_hit
  end

  def down
    remove_column :game_batter_records, :plate_appearence
    remove_column :game_batter_records, :at_bat
    remove_column :game_batter_records, :total_hits
    remove_column :game_batter_records, :one_base_hit
    remove_column :game_batter_records, :two_base_hit
    remove_column :game_batter_records, :three_base_hit
    remove_column :game_batter_records, :home_run
    remove_column :game_batter_records, :strike_out
    remove_column :game_batter_records, :base_on_ball
    remove_column :game_batter_records, :hit_by_pitched_ball
    remove_column :game_batter_records, :sacrifice_hit
    remove_column :game_batter_records, :sacrifice_fly
    remove_column :game_batter_records, :double_play
  end
end
