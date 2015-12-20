module PlayersHelper
	def current_year
		Date.today.strftime("%Y").to_i
	end
end
