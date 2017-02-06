class TotalBatterRecord < ActiveRecord::Base
  belongs_to :player
  include BatterCommonMethods

  def self.summarize
    Player.all.each do |current_player|
      refreshed_records = TotalBatterRecord.batter_records_of_player(current_player)

      if refreshed_records[:played_game] > 0
        total_batter_record_of_player = current_player.total_batter_records.first
        if total_batter_record_of_player
          refreshed_records[:created_at] = total_batter_record_of_player[:created_at]
          refreshed_records[:updated_at] = Time.now()
          total_batter_record_of_player.update(refreshed_records)
        else
          new_batter_records = TotalBatterRecord.new(refreshed_records)
          return false unless new_batter_records.save!
        end
      end
    end

    true
  end

  def self.batter_records_of_player(current_player)
    season_batter_records = current_player.season_batter_records
    plate_appearence = season_batter_records.sum(:plate_appearence)
    is_regular_plate_appearance_satisfied = (200 <= plate_appearence) ? true : false

    @return_hash = {
      player_id: current_player.id,
      is_regular_plate_appearance_satisfied: is_regular_plate_appearance_satisfied,
      played_game: season_batter_records.count,
      plate_appearence: plate_appearence,
    }
    summarize_from_records(@return_hash, season_batter_records)
    @return_hash
  end
end
