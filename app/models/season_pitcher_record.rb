class SeasonPitcherRecord < ActiveRecord::Base
	belongs_to :player

	def self.refresh_season_records(year_to_update = nil)
    year_range = (year_to_update) ? year_to_update..year_to_update : Settings.start_year..Date.today.year
    year_range.each do |year|
      players = Player.all

      players.each do |player|
        pitcher_records_of_season = SeasonPitcherRecord.find_by(
          year: year, player_id: player.id
        )

        refreshed_records = pitcher_records_of_player(player: player, year: year)

        ActiveRecord::Base.transaction do
          if pitcher_records_of_season
            # Update
            pitcher_records_of_season.update(refreshed_records)
          elsif refreshed_records[:pitched_games] > 0
            # New
            new_pitcher_records = SeasonPitcherRecord.new(refreshed_records)
            return false unless new_pitcher_records.save
          end
        end
      end
    end
  end

	def self.pitcher_record_columns
    {
      "Name" => "name",
      "Team" => "team",
      "Back number" => "back_number",
      "G" => "pitched_games",
      "W" => "win",
      "L" => "lose",
      "ERA" => "era",
      "IP" => "inning_pitched",
      "H" => "hit",
      "R" => "run",
      "ER" => "earned_run",
      "HR" => "homerun",
      "BB" => "walk",
      "SO" => "strike_out",
      "HBP" => "hit_by_pitch",
      "WHIP" => "whip",
    }
  end

  def self.pitcher_records_of_player(params)
    player = params[:player]
    game_count = (params[:year]) ? Game.by_year(params[:year]).count : Game.all.count
    is_regular_inning_satisfied = (game_count * Settings.regular_pitching_inning_rate <= player.inning_pitched(params[:year]))
    {
      player_id: player.id,
      year: params[:year],
      pitched_games: player.retrieve_game_pitcher_records("pitcher_games", params[:year]),
      win: player.retrieve_game_pitcher_records("win", params[:year]),
      lose: player.retrieve_game_pitcher_records("lose", params[:year]),
      era: player.era(params[:year]),
      inning_pitched: player.inning_pitched(params[:year]),
      hit: player.retrieve_game_pitcher_records("hit", params[:year]),
      run: player.retrieve_game_pitcher_records("run", params[:year]),
      earned_run: player.retrieve_game_pitcher_records("earned_run", params[:year]),
      homerun: player.retrieve_game_pitcher_records("homerun", params[:year]),
      walk: player.retrieve_game_pitcher_records("walk", params[:year]),
      strike_out: player.retrieve_game_pitcher_records("strike_out", params[:year]),
      hit_by_pitch: player.retrieve_game_pitcher_records("hit_by_pitch", params[:year]),
      whip: player.pitcher_whip(params[:year]),
      is_regular_inning_satisfied: (is_regular_inning_satisfied) ? 1 : 0
    }
  end

  def self.pitcher_records(params)
    players = params[:id] ? Player.where(id: params[:id]) : Player.all
    sort_by_rate = (params[:pitcher_sort] == "ERA" or params[:pitcher_sort] == "WHIP")
    pitcher_sort_param = SeasonPitcherRecord.pitcher_record_columns[params[:pitcher_sort]].to_sym if params[:pitcher_sort]

    @pitcher_records = SeasonPitcherRecord.where(player: players)
    @pitcher_records = @pitcher_records.where(year: params[:year]) if params[:year]

    if params[:pitcher_sort]
      (sort_by_rate) ? @pitcher_records.order(is_regular_inning_satisfied: :desc, pitcher_sort_param => :desc) :
                        @pitcher_records.order(pitcher_sort_param => :desc)
    else
      @pitcher_records
    end
  end
end
