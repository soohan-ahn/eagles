class Game < ActiveRecord::Base
  has_many :at_bat_batter_records
  has_many :game_batter_records
  belongs_to :ground
  belongs_to :league

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
end
