class Player < ActiveRecord::Base
  has_many :game_pitcher_records
  has_many :game_batter_records
  has_many :at_bat_batter_records

  def at_bat_batter_records_this_year(year = nil)
    (year) ? self.at_bat_batter_records.where(game_id: Game.by_year(year).pluck(:id)) : self.at_bat_batter_records
  end

  def game_batter_records_this_year(year = nil)
    (year) ? self.game_batter_records.where(game_id: Game.by_year(year).pluck(:id)) : self.game_batter_records
  end

  def plate_appearence(year = nil)
    at_bat_batter_records_this_year(year).count
  end

  def at_bat(year = nil)
    plate_appearence(year) - retrieve_at_bat_batter_records("base_on_ball", year) - retrieve_at_bat_batter_records("hit_by_pitched_ball", year)
  end

  def total_hits(year = nil)
    total_hits_count = 0
    [:one_base_hit, :two_base_hit, :three_base_hit, :home_run].each do |result|
      total_hits_count += retrieve_at_bat_batter_records(result, year)
    end

    total_hits_count
  end

  def total_base(year = nil)
    total_hits_count = 0
    base = 1
    [:one_base_hit, :two_base_hit, :three_base_hit, :home_run].each do |result|
      total_hits_count += (retrieve_at_bat_batter_records(result, year) * base)
      base += 1
    end

    total_hits_count
  end

  def batting_average(year = nil)
    value = (at_bat(year) == 0) ? 0 : (total_hits(year).to_f / at_bat(year))
    "%.3f" % value
  end

  def on_base_percentage(year = nil)
    value = (plate_appearence(year) == 0) ? 0 : (total_on_base(year).to_f / plate_appearence(year))
    "%.3f" % value
  end

  def total_on_base(year = nil)
    total_hits(year) + retrieve_at_bat_batter_records("base_on_ball", year) + retrieve_at_bat_batter_records("hit_by_pitched_ball", year)
  end

  def slugging_percentage(year = nil)
    value = (at_bat(year) == 0) ? 0 : (total_base(year).to_f / at_bat(year))
    "%.3f" % value
  end

  def ops(year = nil)
    value = slugging_percentage(year).to_f + on_base_percentage(year).to_f
    "%.3f" % value
  end

  def retrieve_at_bat_batter_records(result, year = nil)
    result_codes = Settings.on_base_codes[result.to_sym]
    records = year ? at_bat_batter_records_this_year(year) : self.at_bat_batter_records
    records.where(result_code: result_codes).count
  end

  def retrieve_game_batter_records(result, year = nil)
    result_symbol = result.to_sym
    records = year ? game_batter_records_this_year(year) : self.game_batter_records
    records.pluck(result_symbol).sum
  end




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
    inning_fraction_count = 0.0
    innings.each do |inning|
      fraction = inning.to_f.modulo(1)
      decimal = inning - fraction
      inning_total_count += decimal

      current_fraction = inning_fraction_count.modulo(1)
      if current_fraction >= 0.00 and current_fraction < 0.3
        inning_fraction_count += fraction
      elsif current_fraction >= 0.33 and current_fraction < 0.6
        inning_fraction_count += ( (fraction == 0.33) ? 0.33 : 1 )
      elsif current_fraction >= 0.6
        inning_fraction_count -= 0.66
        inning_fraction_count += ( (fraction == 0.33) ? 1 : 1.33 )
      end
    end

    inning_total_count + inning_fraction_count
  end

  def pitcher_whip(year = nil)
    value = (inning_pitched(year) == 0) ? 0 : (retrieve_game_pitcher_records("walk",year) + retrieve_game_pitcher_records("hit",year)) / inning_pitched(year)
    "%.2f" % value
  end

  def retrieve_game_pitcher_records(result, year = nil)
    result = result.to_sym
    records = year ? game_pitcher_records_this_year(year) :  self.game_pitcher_records
    if result == :pitcher_games
      return records.count
    elsif result == :win or result == :lose
      return records.where(result => true).count
    else
      return records.pluck(result).sum
    end
  end
end
