class GameBatterRecord < ActiveRecord::Base
  def self.new_game_record(params)
    i = 0

    for @batting_order in 1..15
      unless params[:batting_player_name][@batting_order.to_s].empty?
        if !Player.where(name: params[:batting_player_name][@batting_order.to_s]).exists?
          Player.new(name: params[:batting_player_name][@batting_order.to_s]).save
        end

        @params_for_save = GameBatterRecord.params_for_save(params, params[:batting_order][@batting_order.to_s])
        @game_batter_record = GameBatterRecord.new(@params_for_save)
        unless @game_batter_record.save
          return false
        end
      end
    end

    true
  end

  def self.update_game_record(params)
    i = 0

    for @batting_order in 1..15
      unless params[:batting_player_name][@batting_order.to_s].empty?
        if !Player.where(name: params[:batting_player_name][@batting_order.to_s]).exists?
          Player.new(name: params[:batting_player_name][@batting_order.to_s]).save
        end

        @params_for_save = GameBatterRecord.params_for_save(params, @batting_order)
        @game_batter_record = GameBatterRecord.where(
          game_id: @params_for_save[:game_id],
          player_id: @params_for_save[:player_id]).first

        unless @game_batter_record.update(@params_for_save)
          return false
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

  def self.params_for_save(params, batting_order)
    @new_params = { }
    @new_params[:player_id] = Player.where(name: params[:batting_player_name][batting_order.to_s]).first.id
    @new_params[:game_id] = params[:batting_game_id][batting_order.to_s]
    @new_params[:rbi] = (!params[:batting_rbi][batting_order.to_s].empty?) ? params[:batting_rbi][batting_order.to_s] : 0
    @new_params[:run] = (!params[:batting_run][batting_order.to_s].empty?) ? params[:batting_run][batting_order.to_s] : 0
    @new_params[:steal] = (!params[:batting_steal][batting_order.to_s].empty?) ? params[:batting_steal][batting_order.to_s] : 0
    @new_params[:steal_caught] = (!params[:batting_steal_caught][batting_order.to_s].empty?) ? params[:batting_steal_caught][batting_order.to_s] : 0

    @new_params
  end
end
