class GameFielderSimpleRecord < ActiveRecord::Base
  def self.new_game_record(params)
    i = 0

    for @batter_input_order in 1..25
      unless params[:batting_player_name][@batter_input_order.to_s].empty?
        @player = Player.where(name: params[:batting_player_name][@batter_input_order.to_s])
        return false unless @player.exists?

        game_fielder_simple_record_of_game = GameFielderSimpleRecord.find_by(
          player_id: @player.first.id, game_id: params[:batting_game_id][@batter_input_order.to_s],
        )

        @params_for_save = GameFielderSimpleRecord.params_for_save(params, @batter_input_order)

        if game_fielder_simple_record_of_game
          @params_for_save[:updated_at] = Time.now()
          game_fielder_simple_record_of_game.update(@params_for_save)
        else
          @game_field_simple_records = GameFielderSimpleRecord.new(@params_for_save)
          return false unless @game_field_simple_records.save
        end
      end
    end

    true
  end

	def self.destroy_game_record(game_id)
    @game_field_simple_records = GameFielderSimpleRecord.where(game_id: game_id)
    return false unless @game_field_simple_records.destroy_all

    true
  end

  def self.params_for_save(params, batting_order)
    @new_params = { }
    @new_params[:player_id] = Player.where(name: params[:batting_player_name][batting_order.to_s]).first.id
    @new_params[:game_id] = params[:batting_game_id][batting_order.to_s]
    @new_params[:field_error] = (!params[:simple_fielder_error][batting_order.to_s].empty?) ? params[:simple_fielder_error][batting_order.to_s] : 0

    @new_params
  end

  def self.to_hash(params)
    @players = Player.all
    @new_hash = { }
    game_ids = (params[:year]) ? Game.by_year(params[:year]).pluck(:id) : Game.all.pluck(:id)
    @players.each do |player|
      records_of_year = (params[:year]) ? player.season_batter_records.where(year: params[:year]) : player.total_batter_records
      next unless records_of_year.exists?
      next unless records_of_year.first[:played_game] > 0

      records = self.where(player_id: player.id)
      records = records.where(game_id: game_ids) if params[:year]
      @new_hash[player.name.to_sym] = records.pluck(:field_error).sum
    end

    @new_hash.sort {|(k1, v1), (k2, v2)| v2 <=> v1 }
  end
end
