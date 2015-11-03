class AtBatBatterRecord < ActiveRecord::Base
  def self.new_game_record(params)
    i = 0

    for @batting_order in 1..15
      if params[:batting_player_name][@batting_order.to_s] and !Player.where(name: params[:batting_player_name][@batting_order.to_s]).exists?
        Player.new(name: params[:batting_player_name][@batting_order.to_s]).save
      end

      for @inning in 1..9
        if params[:result_code][@inning.to_s][@batting_order.to_s].present?
          @params_for_save = AtBatBatterRecord.params_for_save(params, @inning, @batting_order)

          @game_batter_record = AtBatBatterRecord.new(@params_for_save)
          unless @game_batter_record.save
            return false
          end
        end
      end
    end

    true
  end

  def self.params_for_save(params, inning, batting_order)
    @new_params = { }
    @new_params[:batting_order] = batting_order
    @new_params[:player_id] = Player.where(name: params[:batting_player_name][batting_order.to_s]).first.id
    @new_params[:game_id] = params[:batting_game_id][batting_order.to_s]
    @new_params[:position] = params[:batting_position][batting_order.to_s]
    @new_params[:inning] = inning
    @new_params[:at_plate_order] = 1
    @new_params[:result_code] = params[:result_code][inning.to_s][batting_order.to_s]

    @new_params
  end
end
