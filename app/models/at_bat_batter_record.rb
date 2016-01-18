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

          @params_for_save.each do |param_for_save|
            @game_batter_record = AtBatBatterRecord.new(param_for_save)
            unless @game_batter_record.save
              return false
            end
          end

        end
      end
    end

    true
  end

  def self.update_game_record(params)
    i = 0

    for @batting_order in 1..15
      if !params[:batting_player_name][@batting_order.to_s].empty? and !Player.where(name: params[:batting_player_name][@batting_order.to_s]).exists?
        Player.new(name: params[:batting_player_name][@batting_order.to_s]).save
      end

      for @inning in 1..9
        if params[:result_code][@inning.to_s][@batting_order.to_s].present? and params[:result_code][@inning.to_s][@batting_order.to_s].to_i != 0
          @at_bat_batter_records = AtBatBatterRecord.where(
            inning: @inning,
            batting_order: @batting_order,
            player_id: Player.where(name: params[:batting_player_name][@batting_order.to_s]).first.id,
            game_id: params[:batting_game_id][@batting_order.to_s]
          )
          unless @at_bat_batter_records.destroy_all
            return false
          end

          @params_for_save = AtBatBatterRecord.params_for_save(params, @inning, @batting_order)
          @params_for_save.each do |param_for_save|
            @game_batter_record = AtBatBatterRecord.new(param_for_save)
            unless @game_batter_record.save
              return false
            end
          end

        end
      end
    end

    true
  end

  def self.destroy_game_record(game_id)
    @at_bat_batter_record = AtBatBatterRecord.where(game_id: game_id)
    unless @at_bat_batter_record.destroy_all
      return false
    end
    true
  end

  def self.params_for_save(params, inning, batting_order)
    @result_codes = params[:result_code][inning.to_s][batting_order.to_s].split " "
    @player_id = Player.where(name: params[:batting_player_name][batting_order.to_s]).first.id
    @new_params = [ ]
    @result_codes.each do |result_code|
      @new_param = { }
      @new_param[:batting_order] = batting_order
      @new_param[:player_id] = @player_id
      @new_param[:game_id] = params[:batting_game_id][batting_order.to_s]
      @new_param[:position] = params[:batting_position][batting_order.to_s]
      @new_param[:inning] = inning
      @new_param[:at_plate_order] = 1
      @new_param[:result_code] = result_code
      # @new_params[:result_code] = params[:result_code][inning.to_s][batting_order.to_s]
      @new_params.push @new_param
    end

    @new_params
  end
end
