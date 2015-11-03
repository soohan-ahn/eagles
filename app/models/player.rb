class Player < ActiveRecord::Base
  has_many :game_pitcher_records
  has_many :game_batter_records
  has_many :at_bat_batter_records

  def plate_appearence
    at_bat_batter_records.count
  end

  def at_bat
    plate_appearence - retrieve_at_bat_batter_records("base_on_ball") - retrieve_at_bat_batter_records("hit_by_pitched_ball")
  end

  def total_hits
    total_hits_count = 0
    [:one_base_hit, :two_base_hit, :three_base_hit, :home_run].each do |result|
      total_hits_count += retrieve_at_bat_batter_records(result)
    end

    total_hits_count
  end

  def total_base
    total_hits_count = 0
    base = 1
    [:one_base_hit, :two_base_hit, :three_base_hit, :home_run].each do |result|
      total_hits_count += (retrieve_at_bat_batter_records(result) * base)
      base += 1
    end

    total_hits_count
  end

  def batting_average
    value = (at_bat == 0) ? 0 : (total_hits.to_f / at_bat)
    "%.3f" % value
  end

  def on_base_percentage
    value = (plate_appearence == 0) ? 0 : (total_on_base.to_f / plate_appearence)
    "%.3f" % value
  end

  def total_on_base
    total_hits + retrieve_at_bat_batter_records("base_on_ball") + retrieve_at_bat_batter_records("hit_by_pitched_ball")
  end

  def slugging_percentage
    value = (at_bat == 0) ? 0 : (total_base.to_f / at_bat)
    "%.3f" % value
  end

  def ops
    value = slugging_percentage.to_f + on_base_percentage.to_f
    "%.3f" % value
  end

  def retrieve_at_bat_batter_records(result)
    result_codes = Settings.on_base_codes[result.to_sym]
    self.at_bat_batter_records.where(result_code: result_codes).count
  end

  def retrieve_game_batter_records(result)
    result_symbol = result.to_sym
    self.game_batter_records.pluck(result_symbol).sum
  end

  def era
    value = (inning_pitched == 0) ? 0 : ( retrieve_game_pitcher_records("earned_run") / (inning_pitched * 7))
    "%.2f" % value
  end

  def inning_pitched
    innings = self.game_pitcher_records.pluck(:innings_pitched)
    inning_total_count = 0.0
    inning_fraction_count = 0.0
    innings.each do |inning|
      fraction = inning.to_f.modulo(1)
      decimal = inning - fraction
      inning_total_count += decimal

      current_fraction = inning_fraction_count.modulo(1)
      if current_fraction == 0.00
        inning_fraction_count += fraction
      elsif current_fraction == 0.33
        inning_fraction_count += ( (fraction == 0.33) ? 0.33 : 1 )
      elsif current_fraction == 0.66
        inning_fraction_count -= 0.66
        inning_fraction_count += ( (fraction == 0.33) ? 1 : 1.33 )
      end
    end

    inning_total_count + inning_fraction_count
  end

  def pitcher_whip
    value = (inning_pitched == 0) ? 0 : (retrieve_game_pitcher_records("walk") + retrieve_game_pitcher_records("hit")) / inning_pitched
    "%.2f" % value
  end

  def retrieve_game_pitcher_records(result)
    result = result.to_sym
    if result == :pitcher_games
      return self.game_pitcher_records.count
    elsif result == :win or result == :lose
      return self.game_pitcher_records.where(result => true).count
    else
      return self.game_pitcher_records.pluck(result).sum
    end
  end
end
