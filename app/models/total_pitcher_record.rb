class TotalPitcherRecord < ActiveRecord::Base
  belongs_to :player

  def self.summarize
    players = Player.all

    players.each do |player|
      refreshed_records = TotalPitcherRecord.pitcher_records_of_player(player: player)

      if refreshed_records[:pitched_games] > 0
        # New
        new_pitcher_records = TotalPitcherRecord.new(refreshed_records)
        return false unless new_pitcher_records.save!
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

  def self.pitcher_records_of_player(params)
    player = params[:player]
    season_pitcher_records = player.season_pitcher_records
    is_regular_inning_satisfied = (100 <= season_pitcher_records.sum(:inning_pitched)) ? true : false

    @return_hash = { }
    @columns = TotalPitcherRecord.column_names
    @columns.each do |column|
      unless ["id", "era", "whip"].include?(column)
        if column == "player_id"
          @return_hash[column.to_sym] = player.id
        elsif column == "is_regular_inning_satisfied"
          @return_hash[column.to_sym] = is_regular_inning_satisfied
        elsif column == "inning_pitched"
          innings = season_pitcher_records.pluck(:inning_pitched)
          @return_hash[column.to_sym] = self.total_inning_pitched(innings)
        else
          @return_hash[column.to_sym] = season_pitcher_records.sum(column.to_sym)
        end
      end
    end

    @era = (@return_hash[:earned_run] * 7) / @return_hash[:inning_pitched]
    @return_hash[:era] = "%.2f" % @era

    @whip = (@return_hash[:run] + @return_hash[:hit_by_pitch] + @return_hash[:walk]) / @return_hash[:inning_pitched]
    @return_hash[:whip] = "%.2f" % @whip

    @return_hash
  end

end
