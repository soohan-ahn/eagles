module BatterCommonMethods
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def summarize_from_records(return_hash, player_batter_records)
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
        if !@non_update_columns_in_loop.include?(column) and return_hash[column.to_sym].nil?
          return_hash[column.to_sym] = player_batter_records.sum(column.to_sym)
        end
      end

      batting_average = (return_hash[:at_bat] > 0) ? (return_hash[:total_hits].to_f / return_hash[:at_bat]) : 0.0
      return_hash[:batting_average] = "%.3f" % batting_average

      total_on_base = return_hash[:total_hits] + return_hash[:base_on_ball] + return_hash[:hit_by_pitched_ball]
      on_base_percentage = (return_hash[:plate_appearence] > 0) ? (total_on_base.to_f / return_hash[:plate_appearence]) : 0.0
      return_hash[:on_base_percentage] = "%.3f" % on_base_percentage

      slugging_percentage = return_hash[:one_base_hit] + (return_hash[:two_base_hit] * 2) + (return_hash[:three_base_hit] * 3) + (return_hash[:home_run] * 4)
      slugging_percentage = (return_hash[:at_bat] > 0) ? (slugging_percentage.to_f / return_hash[:at_bat]) : 0
      return_hash[:slugging_percentage] = "%.3f" % slugging_percentage

      return_hash[:ops] = "%.3f" % (slugging_percentage + on_base_percentage)
    end
  end
end