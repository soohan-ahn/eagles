class GameDetailRecordsController < ApplicationController
  before_action :is_admin?, only: [:new, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @game_pircher_records = GamePitcherRecord.all
  end

  # GET /games/new
  def new
    @game = Game.find(params[:game_id])

    redirect_to games_path, notice: 'Game already exists.' if game_detail_records_exists?(@game.id)

    @score_boxes = @game.score_box.split "\t"
    @game_pitcher_record = GamePitcherRecord.new
    @game_pitcher_record_columns = GamePitcherRecord.column_names

    @action = "create"
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:game_id])
    @score_boxes = @game.score_box.split "\t"
    @game_pitcher_records = GamePitcherRecord.pitcher_results_of_game(params[:game_id])
    @game_pitcher_record_columns = GamePitcherRecord.column_names
    @game_batter_record = GameBatterRecord.where(game_id: params[:game_id])
    @at_bat_batter_record = AtBatBatterRecord.batting_result_codes_of_games(@game.id)
    @player_positions = AtBatBatterRecord.player_position(@game.id)

    @current_players = []
    @player_game_batter_records = {}
    @player_game_field_simple_records = {}
    for @batting_order in 0..25
      @current_players[@batting_order] = @game.player_of_at_bat(@batting_order)
      if @current_players[@batting_order].empty?
        @current_players[@batting_order] = [nil]
        next
      end
      @current_players[@batting_order].each do |current_player|
        @player_game_batter_records[current_player.id] = @game_batter_record.where(player: current_player).first
        @player_game_field_simple_records[current_player.id] = current_player.game_field_simple_record_of(@game.id)
      end
    end
    @action = "update"
  end

  # POST /games
  # POST /games.json
  def create
    game = Game.find(params[:game_id]['1']) or redirect_to :back, notice: 'Something wrong. Game not found.'
    year_of_game = game.game_start_time.year

    redirect_to :back, notice: 'Game already exists.' if game_detail_records_exists?(game.id)

    @success = true
    begin
      ActiveRecord::Base.transaction do
        if GamePitcherRecord.summarize(params) and
          AtBatBatterRecord.new_game_record(params) and
          GameBatterRecord.summarize(params) and
          GameFielderSimpleRecord.summarize(params)
          Game.delay.summarize_all(year_of_game)
          redirect_to games_path
        else
          @success = false
          send_mail(e)
          raise ActiveRecord::Rollback
        end
      end
    rescue => e
      send_mail(e)
      raise ActiveRecord::Rollback
    end

    redirect_to :back, notice: 'Something wrong with the input. Check the typeo of the player name' unless @success
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    game = Game.find(params[:game_id]['1']) or redirect_to :back, notice: 'Something wrong. Game not found.'
    year_of_game = game.game_start_time.year

    @success = true
    begin
      ActiveRecord::Base.transaction do
        unless AtBatBatterRecord.destroy_game_record(game.id)
          redirect_to :back, notice: 'Something wrong during the clearing'
        end

        if GamePitcherRecord.summarize(params) and
          AtBatBatterRecord.new_game_record(params) and
          GameBatterRecord.summarize(params) and
          GameFielderSimpleRecord.summarize(params)
          Game.delay.summarize_all(year_of_game)
          redirect_to games_path
        else
          @success = false
          send_mail(e)
          raise ActiveRecord::Rollback
        end
      end
    rescue => e
      send_mail(e)
      raise ActiveRecord::Rollback
    end

    redirect_to :back, notice: 'Something wrong with the input. Check the typeo of the player name' unless @success
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

    def is_admin?
      @current_user ||= User.find_by(id: session[:user_id])
      redirect_to root_path, notice: 'Login required.' unless @current_user

      true
    end

    def send_mail(earned_error)
      mail_subject = "[tokyo-eagles.herokuapp.com] Summarize failed - " + earned_error.message
      mail_body = earned_error.backtrace.join("\n")
      Game.send_mail(mail_subject, mail_body)
    end

    def game_detail_records_exists? (game_id)
      if GamePitcherRecord.where(game_id: game_id).exists? or
        AtBatBatterRecord.where(game_id: game_id).exists? or
        GameBatterRecord.where(game_id: game_id).exists? or
        GameFielderSimpleRecord.where(game_id: game_id).exists?
        return true
      end

      false
    end

end
