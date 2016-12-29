class GameBatterRecord < ActiveRecord::Base
  belongs_to :player

  def self.new_game_record(params)
    i = 0

    for @batter_input_order in 1..25
      unless params[:batting_player_name][@batter_input_order.to_s].empty?
        return false if !Player.where(name: params[:batting_player_name][@batter_input_order.to_s]).exists?

        @params_for_save = GameBatterRecord.params_for_save(params, @batter_input_order)
        @game_batter_record = GameBatterRecord.new(@params_for_save)
        return false unless @game_batter_record.save
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
