class AddIndexToGame < ActiveRecord::Migration
  def up
    add_index :at_bat_batter_records, [:player_id, :game_id]
    add_index :game_batter_records, [:player_id, :game_id], unique: true
    add_index :game_pitcher_records, [:player_id, :game_id], unique: true
    add_index :game_fielder_simple_records, [:player_id, :game_id], unique: true
    add_index :games, [:league_id, :ground_id]
    add_index :season_batter_records, [:player_id, :year], unique: true
    add_index :season_pitcher_records, [:player_id, :year], unique: true
  end

  def down
    remove_index :at_bat_batter_records, column: [:player_id, :game_id]
    remove_index :game_batter_records, column: [:player_id, :game_id]
    remove_index :game_pitcher_records, column: [:player_id, :game_id]
    remove_index :game_fielder_simple_records, column: [:player_id, :game_id]
    remove_index :games, column: [:league_id, :ground_id]
    remove_index :season_batter_records, column: [:player_id, :year]
    remove_index :season_pitcher_records, column: [:player_id, :year]
  end
end
