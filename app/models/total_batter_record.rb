class TotalBatterRecord < ActiveRecord::Base
  belongs_to :player

  def self.summarize
    players = Player.all

    players.each do |player|
      refreshed_records = TotalBatterRecord.batter_records_of_player(player: player)

      if refreshed_records[:played_game] > 0
        # New
        new_batter_records = TotalBatterRecord.new(refreshed_records)
        return false unless new_batter_records.save!
      end
    end

    true
  end

  def self.batter_records_of_player(params)
    player = params[:player]
    season_batter_records = player.season_batter_records
    game_count = Game.all.count
    is_regular_plate_appearance_satisfied = (200 <= player.plate_appearence)

    @return_hash = { }
    @columns = TotalBatterRecord.column_names
    @columns.each do |column|
      unless ["id", "batting_average", "on_base_percentage", "slugging_percentage", "ops"].include?(column)
        if column == "player_id"
          @return_hash[column.to_sym] = player.id
        elsif column == "is_regular_plate_appearance_satisfied"
          @return_hash[column.to_sym] = is_regular_plate_appearance_satisfied
        else
          @return_hash[column.to_sym] = season_batter_records.sum(column.to_sym)
        end
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

    @return_hash[:ops] = @return_hash[:slugging_percentage] + @return_hash[:on_base_percentage]

    @return_hash
  end
end
