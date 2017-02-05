class SeasonBatterRecord < ActiveRecord::Base
  belongs_to :player
  include BatterCommonMethods

  def self.summarize(year_to_update = nil)
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

  def self.batter_records_of_player(params)
  	player = params[:player]

    game_id_of_the_years = (params[:year]) ? Game.by_year(params[:year]).pluck(:id) : Game.all.pluck(:id)
    player_game_batter_records = player.game_batter_records.where(game_id: game_id_of_the_years)

    plate_appearence = player_game_batter_records.sum(:plate_appearence)
    regular_plate_appearance_rate = game_id_of_the_years.count * Settings.regular_plate_appearance_rate
    is_regular_plate_appearance_satisfied = (regular_plate_appearance_rate <= plate_appearence)

    return_hash = {
      player_id: player.id,
      year: params[:year],
      played_game: player_game_batter_records.count,
      is_regular_plate_appearance_satisfied: is_regular_plate_appearance_satisfied,
      plate_appearence: plate_appearence,
    }

    summarize_from_records(return_hash, player_game_batter_records)
    return_hash
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