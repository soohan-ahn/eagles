class GamePitcherRecord < ActiveRecord::Base
  def self.new_game_record(params)
    i = 0

    params[:player_id].each do |pitcher_info|
      (@pitching_order, @pitcher_name) = pitcher_info
      if @pitcher_name.present?
        i = i + 1
        Player.new(name: @pitcher_name).save unless Player.where(name: @pitcher_name).exists?
        @params_for_save = GamePitcherRecord.params_for_save(params, i)
        @game_pitcher_record = GamePitcherRecord.new(@params_for_save)
        unless @game_pitcher_record.save
          return false
        end
      end
    end

    true
  end

  def self.update_game_record(params)
    i = 0

    params[:player_id].each do |pitcher_info|
      (@pitching_order, @pitcher_name) = pitcher_info
      if @pitcher_name.present?
        i = i + 1
        Player.new(name: @pitcher_name).save unless Player.where(name: @pitcher_name).exists?
        @params_for_save = GamePitcherRecord.params_for_save(params, i)
        @game_pitcher_record = GamePitcherRecord.where(
          game_id: @params_for_save[:game_id],
          player_id: @params_for_save[:player_id],
          pitched_order: @pitching_order
        ).first
        unless @game_pitcher_record.update(@params_for_save)
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
      elsif params[@index_symbol][pitched_order.to_s].present?
        @new_params[@index_symbol] = params[@index_symbol][pitched_order.to_s]
      end
    end
    @new_params
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
