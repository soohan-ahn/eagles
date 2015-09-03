class GamePitcherRecordsController < ApplicationController
  before_action :set_game_pircher_record, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @game_pircher_records = GamePitcherRecord.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(game_id)
    @score_boxes = @game.score_box.split "\t"
  end

  # GET /games/new
  def new
    @game = Game.find(params[:game_id])
    @score_boxes = @game.score_box.split "\t"
    @game_pitcher_record = GamePitcherRecord.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    game_params_with_score_box_appended = game_params
    Game.game_params_with_score_box(game_params_with_score_box_appended, params[:scores])
    @game = Game.new(game_params_with_score_box_appended)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_pircher_record
      @game_pitcher_record = GamePitcherRecord.find(params[:id])
    end

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
