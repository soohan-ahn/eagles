class Player < ActiveRecord::Base
  has_many :game_pitcher_records
  has_many :game_fielder_simple_records
  has_many :game_batter_records
  has_many :at_bat_batter_records
  has_many :season_batter_records
  has_many :season_pitcher_records
  has_many :total_batter_records
  has_many :total_pitcher_records

  def game_field_simple_record_of(game_id)
    self.game_fielder_simple_records.find_by(game_id: game_id)
  end

  # Methods for the batters.
  def game_batting_record_of(game_id)
    self.game_batter_records.find_by(game_id: game_id)
  end
end
