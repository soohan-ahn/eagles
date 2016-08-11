class Game < ActiveRecord::Base
  has_many :at_bat_batter_records
  has_many :game_batter_records

  def self.by_year(year)
    where('extract(year from game_start_time) = ?', year)
  end

  def self.new_game_record (params, game_params)
    game_params_with_score_box_appended = game_params
    Game.game_params_with_score_box(game_params_with_score_box_appended, params[:scores])
    @game = Game.new(game_params_with_score_box_appended)

    return false unless @game.save
    return @game
  end

  def update_game_record (params, game_params)
    game_params_with_score_box_appended = game_params
    Game.game_params_with_score_box(game_params_with_score_box_appended, params[:scores])

    return false unless self.update(game_params_with_score_box_appended)
    true
  end

  def self.game_params_with_score_box(game_params, inning_scores)
    score_box_string = ""

    inning_scores.each do |inning_score|
      @score = inning_score.last.to_i
      score_box_string = score_box_string + "#{@score}\t"
    end

    game_params[:score_box] = score_box_string
  end

  def player_of_at_bat(batting_order)
    @players = self.at_bat_batter_records.where(batting_order: batting_order).pluck(:player_id)
    if @players.count > 0
      return Player.where(id: @players)
    else
      return [nil]
    end
  end

  def at_bat_batter_records_of_player(player_id)
    self.at_bat_batter_records.where(player_id: player_id)
  end

  def plate_appearence(player_id)
    at_bat_batter_records_of_player(player_id).count
  end

  def count_of_at_bat_batter_records(result, player_id)
    result_codes = Settings.on_base_codes[result.to_sym]
    records = at_bat_batter_records_of_player(player_id)
    records.where(result_code: result_codes).count
  end

  def at_bat_of_player(player_id)
    plate_appearence(player_id) - count_of_at_bat_batter_records("base_on_ball", player_id) - count_of_at_bat_batter_records("hit_by_pitched_ball", player_id) - count_of_at_bat_batter_records("sacrifies", player_id) - count_of_at_bat_batter_records("not_in_on_base", player_id)
  end

  def hits_of_player(player_id)
    total_hits_count = 0
    [:one_base_hit, :two_base_hit, :three_base_hit, :home_run].each do |result|
      total_hits_count += count_of_at_bat_batter_records(result, player_id)
    end

    total_hits_count
  end
end
