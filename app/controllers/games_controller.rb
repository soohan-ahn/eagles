class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @score_boxes = @game.score_box.split "\t"
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
    @score_boxes = @game.score_box.split "\t"
  end

  # POST /games
  # POST /games.json
  def create
    if Game.new_game_record(params, game_params)
      redirect_to new_game_pitcher_record_path(game_id: @game.id), notice: 'Game was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    if @game.update_game_record(params, game_params)
      redirect_to @game
    else
      format.html { render :edit }
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
=begin
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
=end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:home_team, :away_team, :home_score, :away_score, :stadium, :game_start_time, :score_box)
    end
end
