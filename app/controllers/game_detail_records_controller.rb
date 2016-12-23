class GameDetailRecordsController < ApplicationController
  # GET /games
  # GET /games.json
  def index
    @game_pircher_records = GamePitcherRecord.all
  end

  # GET /games/new
  def new
    @game = Game.find(params[:game_id])
    @score_boxes = @game.score_box.split "\t"
    @game_pitcher_record = GamePitcherRecord.new
    @action = "create"
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:game_id])
    @score_boxes = @game.score_box.split "\t"
    #@game_pitcher_record = GamePitcherRecord.where(game_id: params[:game_id])
    @game_pitcher_records = GamePitcherRecord.pitcher_results_of_game(params[:game_id])
    @game_pitcher_record_columns = GamePitcherRecord.index_of_game_pitcher_records
    @game_batter_record = GameBatterRecord.where(game_id: params[:game_id])
    @at_bat_batter_record = AtBatBatterRecord.batting_result_codes_of_games(@game.id)
    @player_positions = AtBatBatterRecord.player_position(@game.id)
    @action = "update"
  end

  # POST /games
  # POST /games.json
  def create
    ActiveRecord::Base.transaction do
      if GamePitcherRecord.new_game_record(params) and
        AtBatBatterRecord.new_game_record(params) and
        GameBatterRecord.new_game_record(params) and
        SeasonBatterRecord.refresh_season_records(Date.today.year) and
        SeasonPitcherRecord.refresh_season_records(Date.today.year)
        redirect_to games_path
      else
        format.html { redirect_to games_url, notice: 'Game record create failed.' }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    ActiveRecord::Base.transaction do
      if GamePitcherRecord.update_game_record(params) and
         GameBatterRecord.update_game_record(params) and
         AtBatBatterRecord.update_game_record(params) and
         SeasonBatterRecord.refresh_season_records(Date.today.year) and
         SeasonPitcherRecord.refresh_season_records(Date.today.year)
        redirect_to games_path
      else
        format.html { redirect_to games_url, notice: 'Game update failed.' }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(
        :player_id,
        :game_id,
        :pitched_order,
        :win,
        :lose,
        :save_point,
        :hold,
        :innings_pitched,
        :plate_appearance,
        :at_bat,
        :hit,
        :homerun,
        :sacrifice_bunt,
        :sacrifice_fly,
        :run,
        :earned_run,
        :strike_out,
        :walk,
        :intentional_walk,
        :hit_by_pitch,
        :wild_pitch,
        :balk,
        :number_of_pitches,
      )
    end
end
