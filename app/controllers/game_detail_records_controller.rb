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
    game = Game.find(params[:game_id]['1']) or redirect_to :back, notice: 'Something wrong. Game not found.'
    year_of_game = game.game_start_time.year

    begin
      ActiveRecord::Base.transaction do
        if GamePitcherRecord.destroy_game_record(game.id) and
          AtBatBatterRecord.destroy_game_record(game.id) and
          GameBatterRecord.destroy_game_record(game.id) and
          GameFielderSimpleRecord.destroy_game_record(game.id)
        else
          redirect_to :back, notice: 'Something wrong during the clearing'
        end

        if GamePitcherRecord.new_game_record(params) and
          AtBatBatterRecord.new_game_record(params) and
          GameBatterRecord.new_game_record(params) and
          GameFielderSimpleRecord.new_game_record(params) and
          SeasonBatterRecord.refresh_season_records(year_of_game) and
          SeasonPitcherRecord.refresh_season_records(year_of_game)
          redirect_to games_path
        end
      end
    rescue ActiveRecord::RecordInvalid
    ensure
      redirect_to :back, notice: 'Something wrong with the input. Check the typeo of the player name'
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    game = Game.find(params[:game_id]['1']) or redirect_to :back, notice: 'Something wrong. Game not found.'
    year_of_game = game.game_start_time.year

    begin
      ActiveRecord::Base.transaction do
        if GamePitcherRecord.destroy_game_record(game.id) and
          AtBatBatterRecord.destroy_game_record(game.id) and
          GameBatterRecord.destroy_game_record(game.id) and
          GameFielderSimpleRecord.destroy_game_record(game.id)
        else
          redirect_to :back, notice: 'Something wrong during the clearing'
        end

        if GamePitcherRecord.new_game_record(params) and
          AtBatBatterRecord.new_game_record(params) and
          GameBatterRecord.new_game_record(params) and
          GameFielderSimpleRecord.new_game_record(params) and
          SeasonBatterRecord.refresh_season_records(year_of_game) and
          SeasonPitcherRecord.refresh_season_records(year_of_game)
          redirect_to games_path
        end
      end
    rescue ActiveRecord::RecordInvalid
    ensure
      redirect_to :back, notice: 'Something wrong with the input. Check the typeo of the player name'
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
