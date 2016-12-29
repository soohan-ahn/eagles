class GamePitcherRecord < ActiveRecord::Base
  def self.new_game_record(params)
    i = 0

    params[:player_id].each do |pitcher_info|
      (@pitching_order, @pitcher_name) = pitcher_info
      if @pitcher_name.present?
        i = i + 1
        return false unless Player.where(name: @pitcher_name).exists?
        @params_for_save = GamePitcherRecord.params_for_save(params, i)
        @game_pitcher_record = GamePitcherRecord.new(@params_for_save)
        unless @game_pitcher_record.save
          return false
        end
      end
    end

    true
  end

  def self.destroy_game_record(game_id)
    @game_pitcher_record = GamePitcherRecord.where(game_id: game_id)
    unless @game_pitcher_record.destroy_all
      return false
    end
    true
  end

  def self.params_for_save(params, pitched_order)
    @indexes = GamePitcherRecord.index_of_game_pitcher_records
    @new_params = { }
    @indexes.each do |index|
      @index_symbol = index.to_sym
      if index == "player_id"
        @player = Player.where(name: params[@index_symbol][pitched_order.to_s]).first
        @new_params[@index_symbol] = @player.id
      elsif params[@index_symbol].present? and params[@index_symbol][pitched_order.to_s].present?
        @new_params[@index_symbol] = params[@index_symbol][pitched_order.to_s]
        @new_params[@index_symbol] = "%.2f" % @new_params[@index_symbol] if index == "innings_pitched"
        if index == "win" or index == "lose" or index == "save_point" or index == "hold"
          @new_params[@index_symbol] = (params[@index_symbol][pitched_order.to_s] == 1) ? true : params[@index_symbol][pitched_order.to_s]
        end
      end
    end
    @new_params
  end

  def self.pitched_result(pitcher_result)
    return "W" if pitcher_result[:win]
    return "L" if pitcher_result[:lose]
    return "SV" if pitcher_result[:save_point]
    return " "
  end


  def self.pitcher_results_of_game(game_id)
    @pitcher_results = self.where(game_id: game_id)
    @pitcher_results_in_hash = Hash.new
    @pitcher_results.each do |pitcher_result|
      @pitcher_results_in_hash[pitcher_result.pitched_order.to_i] = {
          "pitcher_name" => Player.where(id: pitcher_result.player_id).first.name,
          "details" => pitcher_result,
          "pitched_result" => pitched_result(pitcher_result)
      }
    end

    @pitcher_results_in_hash
  end

  def self.index_of_game_pitcher_records
    [
      "pitched_order",
      "player_id",
      "game_id",
      "win",
      "lose",
      "save_point",
      "hold",
      "innings_pitched",
      "plate_appearance",
      "at_bat",
      "hit",
      "homerun",
      "sacrifice_bunt",
      "sacrifice_fly",
      "run",
      "earned_run",
      "strike_out",
      "walk",
      "intentional_walk",
      "hit_by_pitch",
      "wild_pitch",
      "balk",
      "number_of_pitches",
    ]
  end
end