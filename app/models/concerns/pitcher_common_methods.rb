module PitcherCommonMethods
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def total_inning_pitched(innings)
      inning_total_count = 0.0
      innings.each do |inning|
        inning_total_count += inning
        inning_total_count = inning_total_count.round(2)

        current_fraction = inning_total_count.to_f.modulo(1).round(2)

        inning_total_count += 0.01 if current_fraction == 0.99 or current_fraction == 0.32
      end

      inning_total_count.round(2)
    end

    def summarize_from_records(return_hash, player_pitcher_records)
      non_update_columns_in_loop = ["id", "era", "whip"]
      TotalPitcherRecord.column_names.each do |column|
        if !non_update_columns_in_loop.include?(column) and return_hash[column.to_sym].nil?
          return_hash[column.to_sym] = player_pitcher_records.sum(column.to_sym)
        end
      end

      era = (return_hash[:earned_run] * 7) / return_hash[:inning_pitched]
      return_hash[:era] = "%.2f" % era

      whip = (return_hash[:run] + return_hash[:walk]) / return_hash[:inning_pitched]
      return_hash[:whip] = "%.2f" % whip
    end
  end
end