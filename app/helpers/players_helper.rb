module PlayersHelper
	def current_year
		Date.today.strftime("%Y").to_i
	end

	def date_and_team_of_game(game_id)
		game = Game.find(game_id)
		vs_team = (game.home_team == "Tokyo Eagles") ? game.away_team : game.home_team
		game.game_start_time.strftime("%F") + "\n" + vs_team
	end
end
