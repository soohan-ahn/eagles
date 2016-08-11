class Player < ActiveRecord::Base
  has_many :game_pitcher_records
  has_many :game_batter_records
  has_many :at_bat_batter_records

  def self.batter_record_columns
    ["Name","Team","Back number","G","PA","AB","H","1b","2b","3b","HR","SO","BB","HBP","RBI","Run","Steal","Steal Caught","BA","OBP","SLG","OPS"]
  end

  def self.batter_records(params)
    players = params[:id] ? Player.where(id: params[:id]) : Player.all
    @player_batter_records = {}
    game_count = (params[:year]) ? Game.by_year(params[:year]).count : Game.all.count
    is_sort_by_rate = (params[:batter_sort] == "BA" or params[:batter_sort] == "OBP" or params[:batter_sort] == "SLG" or params[:batter_sort] == "OPS")
    players.each do |player|
      if player.plate_appearence(params[:year]) > 0
        is_regular_plate_appearance_satisfied = (is_sort_by_rate) ? (game_count * Settings.regular_plate_appearance_rate <= player.plate_appearence) : 1

        @player_batter_records[player.id] = {
          "Name" => player.name,
          "Team" => player.team,
          "Back_number" => player.back_number,
          "G" => player.game_batter_records_this_year.count,
          "PA" => player.plate_appearence,
          "AB" => player.at_bat,
          "H" => player.total_hits,
          "1b" => player.retrieve_at_bat_batter_records("one_base_hit", params[:year]),
          "2b" => player.retrieve_at_bat_batter_records("two_base_hit", params[:year]),
          "3b" => player.retrieve_at_bat_batter_records("three_base_hit", params[:year]),
          "HR" => player.retrieve_at_bat_batter_records("home_run", params[:year]),
          "SO" => player.retrieve_at_bat_batter_records("strike_out", params[:year]),
          "BB" => player.retrieve_at_bat_batter_records("base_on_ball", params[:year]),
          "HBP" => player.retrieve_at_bat_batter_records("hit_by_pitched_ball", params[:year]),
          "RBI" => player.retrieve_game_batter_records("rbi", params[:year]),
          "Run" => player.retrieve_game_batter_records("run", params[:year]),
          "Steal" => player.retrieve_game_batter_records("steal", params[:year]),
          "Steal Caught" => player.retrieve_game_batter_records("steal_caught", params[:year]),
          "BA" => player.batting_average,
          "OBP" => player.on_base_percentage,
          "SLG" => player.slugging_percentage,
          "OPS" => player.ops,
          "player_data" => player,
          "is_regular_plate_appearance_satisfied" => (is_regular_plate_appearance_satisfied) ? 1 : 0
        }
      end
    end

    if is_sort_by_rate
      @regular_plate_players = @player_batter_records.select { |_key, value| value["is_regular_plate_appearance_satisfied"] == 1 }
      if @regular_plate_players
        @result = @regular_plate_players.sort_by { |_key, value| value[params[:batter_sort]].to_f }.reverse.collect { |key, value| value }
      end

      @non_regular_plate_players = @player_batter_records.select { |_key, value| value["is_regular_plate_appearance_satisfied"] == 0}
      if @non_regular_plate_players
        @result.concat(@non_regular_plate_players.sort_by { |_key, value| value[params[:batter_sort]].to_f }.reverse.collect { |key, value| value })
      end

      return @result
    else
      return @player_batter_records.sort_by { |_key, value| value[params[:batter_sort]].to_i }.reverse.collect { |key, value| value }
    end
  end

  def self.pitcher_record_columns
    ["Name","Team","Back number","G","W","L","ERA","IP","H","R","ER","HR","BB","SO","HBP","WHIP"]
  end

  def self.pitcher_records(params)
    players = params[:id] ? Player.where(id: params[:id]) : Player.all
    @player_pitcher_records = {}
    players.each do |player|
      if player.retrieve_game_pitcher_records("pitcher_games", params[:year]) > 0
        @player_pitcher_records[player.id] = {
          "Name" => player.name,
          "Team" => player.team,
          "Back_number" => player.back_number,
          "G" => player.retrieve_game_pitcher_records("pitcher_games", params[:year]),
          "W" => player.retrieve_game_pitcher_records("win", params[:year]),
          "L" => player.retrieve_game_pitcher_records("lose", params[:year]),
          "ERA" => player.era(params[:year]),
          "IP" => player.inning_pitched(params[:year]),
          "H" => player.retrieve_game_pitcher_records("hit", params[:year]),
          "R" => player.retrieve_game_pitcher_records("run", params[:year]),
          "ER" => player.retrieve_game_pitcher_records("earned_run", params[:year]),
          "HR" => player.retrieve_game_pitcher_records("homerun", params[:year]),
          "BB" => player.retrieve_game_pitcher_records("walk", params[:year]),
          "SO" => player.retrieve_game_pitcher_records("strike_out", params[:year]),
          "HBP" => player.retrieve_game_pitcher_records("hit_by_pitch", params[:year]),
          "WHIP" => player.pitcher_whip(params[:year]),
          "player_data" => player
        }
      end
    end
    return @player_pitcher_records.sort_by { |_key, value| value[params[:pitcher_sort]] }.reverse.collect { |key, value| value }
  end

  # Methods for the batters.
  def game_batting_record_of(game_id)
    self.game_batter_records.find_by(game_id: game_id)
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
    plate_appearence(year) - retrieve_at_bat_batter_records("base_on_ball", year) - retrieve_at_bat_batter_records("hit_by_pitched_ball", year) - retrieve_at_bat_batter_records("sacrifies", year)
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
    total_hits(year) + retrieve_at_bat_batter_records("base_on_ball", year) + retrieve_at_bat_batter_records("hit_by_pitched_ball", year) + retrieve_at_bat_batter_records("not_in_on_base", year)
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
