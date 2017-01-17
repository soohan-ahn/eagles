class AtBatBatterRecord < ActiveRecord::Base
  belongs_to :player

  def self.batting_result_codes_of_games(game_id)
    @results = Hash.new
    for @inning in 1..10
      @results[@inning] = Hash.new
      for @batting_order in 1..15
        @results[@inning][@batting_order] = Hash.new
      end
    end

    @inning_bat_records = self.where(game_id: game_id)
    if @inning_bat_records.present?
      @inning_bat_records.each do |at_bat_record|
        inning = at_bat_record.inning
        batting_order = at_bat_record.batting_order
        player_name = at_bat_record.player.name
        @results[inning][batting_order][player_name] = Hash.new unless @results[inning][batting_order][player_name]
        @results[inning][batting_order][player_name]["results"] = [] unless @results[inning][batting_order][player_name]["results"]
        @results[inning][batting_order][player_name]["results"].push at_bat_record.result_code
      end
    end
    return @results
  end

  def self.player_position(game_id)
    @bat_records = self.where(game_id: game_id)
    @result = Hash.new
    if @bat_records.present?
      @bat_records.each do |at_bat_record|
        @result[at_bat_record.player.name] = at_bat_record.position
      end
    end

    @result
  end

  def self.new_game_record(params)
    i = 0

    for @batting_order in 1..25
      if params[:batting_player_name][@batting_order.to_s] and !Player.where(name: params[:batting_player_name][@batting_order.to_s]).exists?
        return false
      end

      for @inning in 1..9
        if params[:result_code][@inning.to_s][@batting_order.to_s].present?
          @params_for_save = AtBatBatterRecord.params_for_save(params, @inning, @batting_order, params[:batting_order][@batting_order.to_s])

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

  def self.params_for_save(params, inning, batting_order, displayed_batting_order)
    @result_codes = params[:result_code][inning.to_s][batting_order.to_s].split " "
    @player_id = Player.where(name: params[:batting_player_name][batting_order.to_s]).first.id
    @new_params = [ ]
    @result_codes.each do |result_code|
      @new_param = { }
      @new_param[:batting_order] = displayed_batting_order
      @new_param[:player_id] = @player_id
      @new_param[:game_id] = params[:batting_game_id][batting_order.to_s]
      @new_param[:position] = params[:batting_position][batting_order.to_s]
      @new_param[:inning] = inning
      @new_param[:at_plate_order] = 1
      @new_param[:result_code] = result_code
      @new_params.push @new_param
    end

    @new_params
  end
end
