class SeasonBatterRecord < ActiveRecord::Base
	belongs_to :player

	def self.refresh_season_records(year_to_update = nil)
		year_range = (year_to_update) ? year_to_update..year_to_update : Settings.start_year..Date.today.year
		year_range.each do |year|
			players = Player.all

			players.each do |player|
				batter_records_of_season = SeasonBatterRecord.find_by(
					year: year, player_id: player.id
				)

				refreshed_records = SeasonBatterRecord.batter_records_of_player(player: player, year: year)

				ActiveRecord::Base.transaction do
					if batter_records_of_season
						# Update
						batter_records_of_season.update(refreshed_records)
					elsif refreshed_records[:played_game] > 0
						# New
						new_batter_records = SeasonBatterRecord.new(refreshed_records)
						return false unless new_batter_records.save
					end
				end

			end
		end
	end

	def self.batter_record_columns
    {
      "Name" => "name",
      "Team" => "team",
      "Back number" => "back_number",
      "G" => "played_game",
      "PA" => "plate_appearence",
      "AB" => "at_bat",
      "H" => "total_hits",
      "1b" => "one_base_hit",
      "2b" => "two_base_hit",
      "3b" => "three_base_hit",
      "HR" => "home_run",
      "SO" => "strike_out",
      "BB" => "base_on_ball",
      "HBP" => "hit_by_pitched_ball",
      "RBI" => "rbi",
      "Run" => "run",
      "Steal" => "steal",
      "Steal Caught" => "steal_caught",
      "BA" => "batting_average",
      "OBP" => "on_base_percentage",
      "SLG" => "slugging_percentage",
      "OPS" => "ops",
    }
  end

  def self.batter_records_of_player(params)
  	player = params[:player]
    game_count = (params[:year]) ? Game.by_year(params[:year]).count : Game.all.count
    is_regular_plate_appearance_satisfied = (game_count * Settings.regular_plate_appearance_rate <= player.plate_appearence(params[:year]))

    {
			player_id: player.id,
    	year: params[:year],
    	played_game: player.game_batter_records_this_year.count,
    	plate_appearence: player.plate_appearence(params[:year]),
    	at_bat: player.at_bat(params[:year]),
    	total_hits: player.total_hits(params[:year]),
      one_base_hit: player.retrieve_at_bat_batter_records("one_base_hit", params[:year]),
      two_base_hit: player.retrieve_at_bat_batter_records("two_base_hit", params[:year]),
      three_base_hit: player.retrieve_at_bat_batter_records("three_base_hit", params[:year]),
      home_run: player.retrieve_at_bat_batter_records("home_run", params[:year]),
      strike_out: player.retrieve_at_bat_batter_records("strike_out", params[:year]),
      base_on_ball: player.retrieve_at_bat_batter_records("base_on_ball", params[:year]),
      hit_by_pitched_ball: player.retrieve_at_bat_batter_records("hit_by_pitched_ball", params[:year]),
      rbi: player.retrieve_game_batter_records("rbi", params[:year]),
      run: player.retrieve_game_batter_records("run", params[:year]),
      steal: player.retrieve_game_batter_records("steal", params[:year]),
      steal_caught: player.retrieve_game_batter_records("steal_caught", params[:year]),
      batting_average: player.batting_average(params[:year]),
      on_base_percentage: player.on_base_percentage(params[:year]),
      slugging_percentage: player.slugging_percentage(params[:year]),
      ops: player.ops(params[:year]),
      is_regular_plate_appearance_satisfied: (is_regular_plate_appearance_satisfied) ? true : false,
    }
  end

  def self.batter_records(params)
    players = params[:id] ? Player.where(id: params[:id]) : Player.all
    sort_by_rate = (params[:batter_sort] == "BA" or
      params[:batter_sort] == "OBP" or
      params[:batter_sort] == "SLG" or
      params[:batter_sort] == "OPS"
    )
    sort_by_player = (params[:batter_sort] == "Name" or
      params[:batter_sort] == "Team" or
      params[:batter_sort] == "Back number"
    )
    batter_sort_param = SeasonBatterRecord.batter_record_columns[params[:batter_sort]].to_sym if params[:batter_sort]

    @batter_records = SeasonBatterRecord.where(player: players)
    @batter_records = @batter_records.where(year: params[:year]) if params[:year]

    if sort_by_player
      symbol_to_sort = (params[:batter_sort] == "Name") ? :name : (params[:batter_sort] == "Team") ? :team : :back_number
      @batter_records.sort { |a,b| a.player[symbol_to_sort].to_s <=> b.player[symbol_to_sort].to_s }
    elsif params[:batter_sort]
      (sort_by_rate) ? @batter_records.order(is_regular_plate_appearance_satisfied: :desc, batter_sort_param => :desc) :
                        @batter_records.order(batter_sort_param => :desc)
    else
      @batter_records
    end
  end
end