class SeasonBatterRecord < ActiveRecord::Base
  belongs_to :player
  include BatterCommonMethods

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

  def self.batter_records_of_player(params)
  	player = params[:player]
    game_count = (params[:year]) ? Game.by_year(params[:year]).count : Game.all.count
    is_regular_plate_appearance_satisfied = (game_count * Settings.regular_plate_appearance_rate <= player.plate_appearence(params[:year]))

    {
      player_id: player.id,
      year: params[:year],
      played_game: player.game_batter_records_this_year(params[:year]).count,
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
      sacrifice_hit: player.retrieve_at_bat_batter_records("sacrifice_bunts", params[:year]),
      sacrifice_fly: player.retrieve_at_bat_batter_records("sacrifice_flys", params[:year]),
      double_play: player.retrieve_at_bat_batter_records("double_plays", params[:year]),
      batting_average: player.batting_average(params[:year]),
      on_base_percentage: player.on_base_percentage(params[:year]),
      slugging_percentage: player.slugging_percentage(params[:year]),
      ops: player.ops(params[:year]),
      is_regular_plate_appearance_satisfied: (is_regular_plate_appearance_satisfied) ? true : false,
      on_base_by_error: player.retrieve_at_bat_batter_records("on_base_by_error", params[:year]),
    }
  end

  def self.batter_records(params)
    players = params[:id] ? Player.where(id: params[:id]) : Player.all
    sort_by_rate = (params[:batter_sort] == "batting_average" or
      params[:batter_sort] == "on_base_percentage" or
      params[:batter_sort] == "slugging_percentage" or
      params[:batter_sort] == "ops"
    )
    sort_by_player = (params[:batter_sort] == "name" or
      params[:batter_sort] == "team" or
      params[:batter_sort] == "back_number"
    )
    batter_sort_param = params[:batter_sort].to_sym if params[:batter_sort]

    if params[:year]
      @batter_records = SeasonBatterRecord.where(player: players)
      @batter_records = @batter_records.where(year: params[:year]).where("played_game > 0")
    else
      @batter_records = TotalBatterRecord.where(player: players)
    end

    if sort_by_player
      if params[:batter_sort] == "name"
        @batter_records.sort { |a,b| a.player.name.to_s <=> b.player.name.to_s }
      elsif params[:batter_sort] == "team"
        @batter_records.sort { |a,b| b.player.team.to_s <=> a.player.team.to_s }
      else
        @batter_records.sort do |a,b|
          if a.player.back_number == nil or b.player.back_number == nil
            b.player.back_number.to_i <=> a.player.back_number.to_i
          else
            a.player.back_number.to_i <=> b.player.back_number.to_i
          end
        end
      end
    elsif params[:batter_sort]
      (sort_by_rate) ? @batter_records.order(is_regular_plate_appearance_satisfied: :desc, batter_sort_param => :desc) :
                        @batter_records.order(batter_sort_param => :desc)
    else
      @batter_records
    end
  end
end