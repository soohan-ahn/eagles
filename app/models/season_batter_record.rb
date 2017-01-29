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

        if batter_records_of_season
          # Update
          refreshed_records[:created_at] = batter_records_of_season[:created_at]
          refreshed_records[:updated_at] = Time.now()
          batter_records_of_season.update!(refreshed_records)
        elsif refreshed_records[:played_game] > 0
          # New
          new_batter_records = SeasonBatterRecord.new(refreshed_records)
          return false unless new_batter_records.save
        end
      end
    end
  end

	def self.batter_record_columns # TODO: Move to the locales.yml
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
      "Error" => "on_base_by_error",
      "Sacrifice Hit" => "sacrifice_hit",
      "Sacrifice Fly" => "sacrifice_fly",
      "Double play" => "double_play",
      "BA" => "batting_average",
      "OBP" => "on_base_percentage",
      "SLG" => "slugging_percentage",
      "OPS" => "ops",
    }
  end

  def self.batter_records_of_player(params)
  	player = params[:player]

    game_id_of_the_years = (params[:year]) ? Game.by_year(params[:year]).pluck(:id) : Game.all.pluck(:id)
    player_game_batter_records = player.game_batter_records.where(game_id: game_id_of_the_years)

    @plate_appearence = player_game_batter_records.sum(:plate_appearence)
    regular_plate_appearance_rate = game_id_of_the_years.count * Settings.regular_plate_appearance_rate
    is_regular_plate_appearance_satisfied = (regular_plate_appearance_rate <= @plate_appearence)

    @return_hash = {
      player_id: player.id,
      year: params[:year],
      played_game: player_game_batter_records.count,
      is_regular_plate_appearance_satisfied: is_regular_plate_appearance_satisfied,
      plate_appearence: @plate_appearence,
    }
    @non_update_columns_in_loop = [
      "id",
      "batting_average",
      "on_base_percentage",
      "slugging_percentage",
      "ops",
      "created_at",
      "updated_at",
    ]
    SeasonBatterRecord.column_names.each do |column|
      if !@non_update_columns_in_loop.include?(column) and @return_hash[column.to_sym].nil?
        @return_hash[column.to_sym] = player_game_batter_records.sum(column.to_sym)
      end
    end

    @batting_average = (@return_hash[:at_bat] > 0) ? (@return_hash[:total_hits].to_f / @return_hash[:at_bat]) : 0.0
    @return_hash[:batting_average] = "%.3f" % @batting_average

    @total_on_base = @return_hash[:total_hits] + @return_hash[:base_on_ball] + @return_hash[:hit_by_pitched_ball]
    @on_base_percentage = (@return_hash[:plate_appearence] > 0) ? (@total_on_base.to_f / @return_hash[:plate_appearence]) : 0.0
    @return_hash[:on_base_percentage] = "%.3f" % @on_base_percentage

    @slugging_percentage = @return_hash[:one_base_hit] + (@return_hash[:two_base_hit] * 2) + (@return_hash[:three_base_hit] * 3) + (@return_hash[:home_run] * 4)
    @slugging_percentage = (@return_hash[:at_bat] > 0) ? (@slugging_percentage.to_f / @return_hash[:at_bat]) : 0
    @return_hash[:slugging_percentage] = "%.3f" % @slugging_percentage

    @return_hash[:ops] = "%.3f" % (@slugging_percentage + @on_base_percentage)

    @return_hash
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

    if params[:year]
      @batter_records = SeasonBatterRecord.where(player: players)
      @batter_records = @batter_records.where(year: params[:year]).where("played_game > 0")
    else
      @batter_records = TotalBatterRecord.where(player: players)
    end

    if sort_by_player
      if params[:batter_sort] == "Name"
        @batter_records.sort { |a,b| a.player.name.to_s <=> b.player.name.to_s }
      elsif params[:batter_sort] == "Team"
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