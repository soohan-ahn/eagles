class GamePitcherRecord < ActiveRecord::Base
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
