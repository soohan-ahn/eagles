class Player < ActiveRecord::Base
  has_many :game_pitcher_records
  has_many :game_batter_records
  has_many :at_bat_batter_records

  def self.sorted_list(params, sorting_for)
    @sorted_list = Player.all
    if params[:batter_sort] or params[:pitcher_sort]
      @player_hash = {}
      @sorted_list.each do |player|
        @player_hash[player] = (sorting_for == "batter") ? player.batter_sotring_value(params) : player.pitcher_sotring_value(params)
      end

      return @player_hash.sort_by { |_key, value| value }.reverse.collect { |key, value| key }
    end
    return @sorted_list
  end

  def pitcher_sotring_value(params)
    if params[:pitcher_sort] == "G"
      retrieve_game_pitcher_records("pitcher_games", params[:year])
    elsif params[:pitcher_sort] == "W"
      retrieve_game_pitcher_records("win", params[:year])
    elsif params[:pitcher_sort] == "L"
      retrieve_game_pitcher_records("lose", params[:year])
    elsif params[:pitcher_sort] == "ERA"
      era(params[:year])
    elsif params[:pitcher_sort] == "IP"
      inning_pitched(params[:year])
    elsif params[:pitcher_sort] == "H"
      retrieve_game_pitcher_records("hit", params[:year])
    elsif params[:pitcher_sort] == "R"
      retrieve_game_pitcher_records("run", params[:year])
    elsif params[:pitcher_sort] == "ER"
      retrieve_game_pitcher_records("earned_run", params[:year])
    elsif params[:pitcher_sort] == "HR"
      retrieve_game_pitcher_records("homerun", params[:year])
    elsif params[:pitcher_sort] == "BB"
      retrieve_game_pitcher_records("walk", params[:year])
    elsif params[:pitcher_sort] == "SO"
      retrieve_game_pitcher_records("strike_out", params[:year])
    elsif params[:pitcher_sort] == "HBP"
      retrieve_game_pitcher_records("hit_by_pitch", params[:year])
    elsif params[:pitcher_sort] == "WHIP"
      pitcher_whip(params[:year])
    else return nil
    end
  end

  def batter_sotring_value(params)
    if params[:batter_sort] == "G"
      game_batter_records_this_year(params[:year]).count
    elsif params[:batter_sort] == "PA"
      plate_appearence(params[:year])
    elsif params[:batter_sort] =="AB"
      at_bat(params[:year])
    elsif params[:batter_sort] =="H"
      total_hits(params[:year])
    elsif params[:batter_sort] =="1b"
      retrieve_at_bat_batter_records("one_base_hit", params[:year])
    elsif params[:batter_sort] =="2b"
      retrieve_at_bat_batter_records("two_base_hit", params[:year])
    elsif params[:batter_sort] =="3b"
      retrieve_at_bat_batter_records("three_base_hit", params[:year])
    elsif params[:batter_sort] =="HR"
      retrieve_at_bat_batter_records("home_run", params[:year])
    elsif params[:batter_sort] =="BB"
      retrieve_at_bat_batter_records("base_on_ball", params[:year])
    elsif params[:batter_sort] =="HBP"
      retrieve_at_bat_batter_records("hit_by_pitched_ball", params[:year])
    elsif params[:batter_sort] =="RBI"
      retrieve_game_batter_records("rbi", params[:year])
    elsif params[:batter_sort] =="Run"
      retrieve_game_batter_records("run", params[:year])
    elsif params[:batter_sort] =="Steal"
      retrieve_game_batter_records("steal", params[:year])
    elsif params[:batter_sort] =="Steal Caught"
      retrieve_game_batter_records("steal_caught", params[:year])
    elsif params[:batter_sort] =="BA"
      batting_average(params[:year])
    elsif params[:batter_sort] =="OBP"
      on_base_percentage(params[:year])
    elsif params[:batter_sort] =="SLG"
      slugging_percentage(params[:year])
    elsif params[:batter_sort] =="OPS"
      ops(params[:year])
    else return nil
    end
  end

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
