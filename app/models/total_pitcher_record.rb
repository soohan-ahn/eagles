class TotalPitcherRecord < ActiveRecord::Base
  belongs_to :player
  include PitcherCommonMethods

  def self.summarize
    Player.all.each do |current_player|
      refreshed_records = TotalPitcherRecord.pitcher_records_of_player(current_player)

      if refreshed_records[:pitched_games] > 0
        total_pitcher_record = current_player.total_pitcher_records.first
        if total_pitcher_record
          refreshed_records[:created_at] = total_pitcher_record[:created_at]
          refreshed_records[:updated_at] = Time.now()
          total_pitcher_record.update(refreshed_records)
        else
          new_pitcher_records = TotalPitcherRecord.new(refreshed_records)
          return false unless new_pitcher_records.save!
        end
      end
    end

    true
  end

  def self.pitcher_records_of_player(current_player)
    season_pitcher_records = current_player.season_pitcher_records
    innings = season_pitcher_records.pluck(:inning_pitched)
    innings_sum = self.total_inning_pitched(innings)
    is_regular_inning_satisfied = (100 <= innings_sum) ? true : false

    return_hash = {
      player_id: current_player.id,
      is_regular_inning_satisfied: is_regular_inning_satisfied,
      inning_pitched: innings_sum,
      pitched_games: season_pitcher_records.sum(:pitched_games)
    }
    summarize_from_records(return_hash, season_pitcher_records)

    return_hash
  end
end
