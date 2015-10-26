class Player < ActiveRecord::Base
  has_many :game_pitcher_records
  has_many :game_batter_records

  def plate_appearence
    game_batter_records.count
  end

  def at_bat
    plate_appearence - retrieve_game_batter_records("base_on_ball") - retrieve_game_batter_records("hit_by_pitched_ball")
  end

  def total_hits
    total_hits_count = 0
    [:one_base_hit, :two_base_hit, :three_base_hit, :home_run].each do |result|
      total_hits_count += retrieve_game_batter_records(result)
    end

    total_hits_count
  end

  def total_base
    total_hits_count = 0
    base = 1
    [:one_base_hit, :two_base_hit, :three_base_hit, :home_run].each do |result|
      total_hits_count += (retrieve_game_batter_records(result) * base)
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
    total_hits + retrieve_game_batter_records("base_on_ball") + retrieve_game_batter_records("hit_by_pitched_ball")
  end

  def slugging_percentage
    value = (at_bat == 0) ? 0 : (total_base.to_f / at_bat)
    "%.3f" % value
  end

  def ops
    value = slugging_percentage.to_f + on_base_percentage.to_f
    "%.3f" % value
  end

  def retrieve_game_batter_records(result)
    result_codes = Settings.on_base_codes[result.to_sym]
    self.game_batter_records.where(result_code: result_codes).count
  end
end
