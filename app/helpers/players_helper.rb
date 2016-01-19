module PlayersHelper
	def current_year
		Date.today.strftime("%Y").to_i
	end

	def year_month_date_of_game(game_id)
		Game.find(game_id).game_start_time.strftime("%F")
	end
end
