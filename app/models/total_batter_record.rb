class TotalBatterRecord < ActiveRecord::Base
  belongs_to :player

  def self.summarize
    Player.all.each do |current_player|
      @refreshed_records = TotalBatterRecord.batter_records_of_player(current_player)

      if @refreshed_records[:played_game] > 0
        @total_batter_record_of_player = current_player.total_batter_records.first
        if @total_batter_record_of_player
          @refreshed_records[:created_at] = @total_batter_record_of_player[:created_at]
          @refreshed_records[:updated_at] = Time.now()
          @total_batter_record.update(refreshed_records)
        else
          @new_batter_records = TotalBatterRecord.new(@refreshed_records)
          return false unless @new_batter_records.save!
        end
      end
    end

    true
  end

  def self.batter_records_of_player(current_player)
    @season_batter_records = current_player.season_batter_records
    is_regular_plate_appearance_satisfied = (200 <= @season_batter_records.sum(:plate_appearence)) ? true : false

    @return_hash = {
      player_id: current_player.id,
      is_regular_plate_appearance_satisfied: is_regular_plate_appearance_satisfied,
      played_game: @season_batter_records.count,
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
    TotalBatterRecord.column_names.each do |column|
      if !@non_update_columns_in_loop.include?(column) and @return_hash[column.to_sym].nil?
        @return_hash[column.to_sym] = @season_batter_records.sum(column.to_sym)
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
end
