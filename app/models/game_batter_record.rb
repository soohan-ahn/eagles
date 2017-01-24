class GameBatterRecord < ActiveRecord::Base
  belongs_to :player

  def self.new_game_record(params)
    i = 0

    for @batter_input_order in 1..25
      unless params[:batting_player_name][@batter_input_order.to_s].empty?
        @player = Player.where(name: params[:batting_player_name][@batter_input_order.to_s])
        return false unless @player.exists?

        batter_records_of_season = GameBatterRecord.find_by(
          game_id: params[:batting_game_id][@batter_input_order.to_s], player_id: @player.first.id
        )

        @params_for_save = GameBatterRecord.params_for_save(params, @batter_input_order)
        if batter_records_of_season
          #@params_for_save[:created_at] = batter_records_of_season[:created_at]
          @params_for_save[:updated_at] = Time.now()
          batter_records_of_season.update!(@params_for_save)
        else
          @game_batter_record = GameBatterRecord.new(@params_for_save)
          return false unless @game_batter_record.save
        end
      end
    end

    true
  end

  def self.destroy_game_record(game_id)
    @game_batter_record = GameBatterRecord.where(game_id: game_id)
    unless @game_batter_record.destroy_all
      return false
    end
    true
  end

  def self.retrieve_at_bat_batter_records(result, records)
    result_codes = Settings.on_base_codes[result.to_sym]
    result_codes = result_codes.map { |i| i.to_s }
    records.select{ |r| result_codes.include?(r) }.count
  end

  def self.params_for_save(params, batting_order)
    @new_params = { }
    @record_codes = [ ]
    (1..9).each do |inning|
      unless params[:result_code][inning.to_s][batting_order.to_s].to_s.strip.empty?
        @record_codes = @record_codes.push(params[:result_code][inning.to_s][batting_order.to_s].split " ").flatten
      end
    end

    @new_params = {
      player_id: Player.where(name: params[:batting_player_name][batting_order.to_s]).first.id,
      game_id: params[:batting_game_id][batting_order.to_s],
      rbi: (!params[:batting_rbi][batting_order.to_s].empty?) ? params[:batting_rbi][batting_order.to_s] : 0,
      run: (!params[:batting_run][batting_order.to_s].empty?) ? params[:batting_run][batting_order.to_s] : 0,
      steal: (!params[:batting_steal][batting_order.to_s].empty?) ? params[:batting_steal][batting_order.to_s] : 0,
      steal_caught: (!params[:batting_steal_caught][batting_order.to_s].empty?) ? params[:batting_steal_caught][batting_order.to_s] : 0,
      plate_appearence: @record_codes.count,
      one_base_hit: self.retrieve_at_bat_batter_records("one_base_hit", @record_codes),
      two_base_hit: self.retrieve_at_bat_batter_records("two_base_hit", @record_codes),
      three_base_hit: self.retrieve_at_bat_batter_records("three_base_hit", @record_codes),
      home_run: self.retrieve_at_bat_batter_records("home_run", @record_codes),
      strike_out: self.retrieve_at_bat_batter_records("strike_out", @record_codes),
      base_on_ball: self.retrieve_at_bat_batter_records("base_on_ball", @record_codes),
      hit_by_pitched_ball: self.retrieve_at_bat_batter_records("hit_by_pitched_ball", @record_codes),
      sacrifice_hit: self.retrieve_at_bat_batter_records("sacrifice_bunts", @record_codes),
      sacrifice_fly: self.retrieve_at_bat_batter_records("sacrifice_flys", @record_codes),
      double_play: self.retrieve_at_bat_batter_records("double_plays", @record_codes),
    }
    @new_params[:at_bat] = @new_params[:plate_appearence] - @new_params[:base_on_ball] - @new_params[:hit_by_pitched_ball] - self.retrieve_at_bat_batter_records("sacrifies", @record_codes) - self.retrieve_at_bat_batter_records("not_in_on_base", @record_codes)
    @new_params[:total_hits] = @new_params[:one_base_hit] + @new_params[:two_base_hit] + @new_params[:three_base_hit] + @new_params[:home_run]

    @new_params
  end
end
