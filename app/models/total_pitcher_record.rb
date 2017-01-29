class TotalPitcherRecord < ActiveRecord::Base
  belongs_to :player

  def self.summarize
    Player.all.each do |current_player|
      @refreshed_records = TotalPitcherRecord.pitcher_records_of_player(current_player)

      if @refreshed_records[:pitched_games] > 0
        @total_pitcher_record = current_player.total_pitcher_records.first
        if @total_pitcher_record
          @refreshed_records[:created_at] = @total_pitcher_record[:created_at]
          @refreshed_records[:updated_at] = Time.now()
          total_pitcher_record.update(@refreshed_records)
        else
          @new_pitcher_records = TotalPitcherRecord.new(@refreshed_records)
          return false unless @new_pitcher_records.save!
        end
      end
    end

    true
  end

  def self.total_inning_pitched(innings)
    inning_total_count = 0.0
    innings.each do |inning|
      inning_total_count += inning
      inning_total_count = inning_total_count.round(2)

      current_fraction = inning_total_count.to_f.modulo(1).round(2)

      inning_total_count += 0.01 if current_fraction == 0.99 or current_fraction == 0.32
    end

    inning_total_count.round(2)
  end

  def self.pitcher_records_of_player(current_player)
    @season_pitcher_records = current_player.season_pitcher_records
    @is_regular_inning_satisfied = (100 <= @season_pitcher_records.sum(:inning_pitched)) ? true : false

    @innings = @season_pitcher_records.pluck(:inning_pitched)
    @innings_sum = self.total_inning_pitched(@innings)

    @return_hash = {
      player_id: current_player.id,
      is_regular_inning_satisfied: @is_regular_inning_satisfied,
      inning_pitched: @innings_sum,
      pitched_games: @season_pitcher_records.count
    }
    @non_update_columns_in_loop = ["id", "era", "whip"]
    TotalPitcherRecord.column_names.each do |column|
      if !@non_update_columns_in_loop.include?(column) and @return_hash[column.to_sym].nil?
        @return_hash[column.to_sym] = @season_pitcher_records.sum(column.to_sym)
      end
    end

    @era = (@return_hash[:earned_run] * 7) / @return_hash[:inning_pitched]
    @return_hash[:era] = "%.2f" % @era

    @whip = (@return_hash[:run] + @return_hash[:hit_by_pitch] + @return_hash[:walk]) / @return_hash[:inning_pitched]
    @return_hash[:whip] = "%.2f" % @whip

    @return_hash
  end

end
