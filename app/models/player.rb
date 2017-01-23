class Player < ActiveRecord::Base
  has_many :game_pitcher_records
  has_many :game_fielder_simple_records
  has_many :game_batter_records
  has_many :at_bat_batter_records
  has_many :season_batter_records
  has_many :season_pitcher_records

  def game_field_simple_record_of(game_id)
    self.game_fielder_simple_records.find_by(game_id: game_id)
  end

  # Methods for the batters.
  def game_batting_record_of(game_id)
    self.game_batter_records.find_by(game_id: game_id)
  end

  # Methods for the pitchers.
  def game_pitcher_records_this_year(year = nil)
    (year) ? self.game_pitcher_records.where(game_id: Game.by_year(year).pluck(:id)) : self.game_pitcher_records
  end

  def era(year = nil)
    value = (inning_pitched(year) == 0) ? 0 : ( (retrieve_game_pitcher_records("earned_run", year) * 7) / inning_pitched(year))
    "%.2f" % value
  end

  def inning_pitched(year = nil)
    records = year ? game_pitcher_records_this_year(year) :  self.game_pitcher_records

    innings = records.pluck(:innings_pitched)
    inning_total_count = 0.0
    innings.each do |inning|
      inning_total_count += inning
      inning_total_count = inning_total_count.round(2)

      current_fraction = inning_total_count.to_f.modulo(1).round(2)

      inning_total_count += 0.01 if current_fraction == 0.99 or current_fraction == 0.32
    end

    inning_total_count.round(2)
  end

  def pitcher_whip(year = nil)
    value = (inning_pitched(year) == 0) ? 0 : (retrieve_game_pitcher_records("walk",year) + retrieve_game_pitcher_records("hit",year)) / inning_pitched(year)
    "%.2f" % value
  end

  def retrieve_game_pitcher_records(result, year = nil)
    result = result.to_sym
    records = year ? game_pitcher_records_this_year(year) : self.game_pitcher_records
    if result == :pitcher_games
      return records.count
    elsif result == :win or result == :lose
      return records.where(result => true).count
    else
      return records.pluck(result).sum
    end
  end
end
