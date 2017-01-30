class SeasonPitcherRecord < ActiveRecord::Base
	belongs_to :player
  include PitcherCommonMethods

	def self.refresh_season_records(year_to_update = nil)
    year_range = (year_to_update) ? year_to_update..year_to_update : Settings.start_year..Date.today.year
    year_range.each do |year|
      players = Player.all

      players.each do |player|
        pitcher_records_of_season = SeasonPitcherRecord.find_by(
          year: year, player_id: player.id
        )

        refreshed_records = pitcher_records_of_player(player: player, year: year)

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

  def self.pitcher_records_of_player(params)
    current_player = params[:player]
    game_pitcher_records = current_player.game_pitcher_records
    innings = game_pitcher_records.pluck(:innings_pitched)
    innings_sum = self.total_inning_pitched(innings)
    game_count = (params[:year]) ? Game.by_year(params[:year]).count : Game.all.count
    is_regular_inning_satisfied = (game_count * Settings.regular_pitching_inning_rate <= innings_sum)

    return_hash = {
      year: params[:year],
      player_id: current_player.id,
      is_regular_inning_satisfied: is_regular_inning_satisfied,
      inning_pitched: innings_sum,
      pitched_games: game_pitcher_records.count,
      win: game_pitcher_records.where(win: true).count,
      lose: game_pitcher_records.where(lose: true).count,
    }
    summarize_from_records(return_hash, game_pitcher_records)

    return_hash
  end

  def self.pitcher_records(params)
    players = params[:id] ? Player.where(id: params[:id]) : Player.all
    sort_by_rate = (params[:pitcher_sort] == "era" or params[:pitcher_sort] == "whip")
    sort_by_player = (params[:pitcher_sort] == "name" or
      params[:pitcher_sort] == "team" or
      params[:pitcher_sort] == "back_number"
    )
    pitcher_sort_param = params[:pitcher_sort] if params[:pitcher_sort]

    if params[:year]
      @pitcher_records = SeasonPitcherRecord.where(player: players)
      @pitcher_records = @pitcher_records.where(year: params[:year]).where("pitched_games > 0")
    else
      @pitcher_records = TotalPitcherRecord.where(player: players)
    end

    if sort_by_player
      if params[:pitcher_sort] == "name"
        @pitcher_records.sort { |a,b| b.player.name.to_s <=> a.player.name.to_s }
      elsif params[:pitcher_sort] == "team"
        @pitcher_records.sort { |a,b| a.player.team.to_s <=> b.player.team.to_s }
      else
        @pitcher_records.sort do |a,b|
          if a.player.back_number == nil or b.player.back_number == nil
            b.player.back_number.to_i <=> a.player.back_number.to_i 
          else
            a.player.back_number.to_i <=> b.player.back_number.to_i 
          end
        end
      end
    elsif params[:pitcher_sort]
      (sort_by_rate) ? @pitcher_records.order(is_regular_inning_satisfied: :desc, pitcher_sort_param => :asc) :
                        @pitcher_records.order(pitcher_sort_param => :desc)
    else
      @pitcher_records
    end
  end
end
