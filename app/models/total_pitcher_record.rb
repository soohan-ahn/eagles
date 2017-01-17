class TotalPitcherRecord < ActiveRecord::Base
  belongs_to :player

  def self.summarize
    players = Player.all

    players.each do |player|
      refreshed_records = SeasonPitcherRecord.pitcher_records_of_player(player: player)
      refreshed_records.delete(:year)
      refreshed_records[:is_regular_inning_satisfied] = (100 <= player.inning_pitched) ? 1 : 0

      ActiveRecord::Base.transaction do
        if refreshed_records[:pitched_games] > 0
          # New
          new_pitcher_records = TotalPitcherRecord.new(refreshed_records)
          return false unless new_pitcher_records.save
        end
      end
    end
  end
end
