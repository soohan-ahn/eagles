module ApplicationHelper
  def batting_result_code(at_bat_batter_record, batting_order, inning)
    @results = [ ]
    @inning_bat_records = at_bat_batter_record.where(batting_order: batting_order, inning: inning)
    if @inning_bat_records.present?
      @inning_bat_records.each do |at_bat_record|
        @results.push Settings.result_code[at_bat_record.result_code]
      end
    end
    return @results
  end
end
