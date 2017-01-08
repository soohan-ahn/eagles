class AddColumnToSeasonBatterRecord < ActiveRecord::Migration
  def up
    add_column :season_batter_records, :on_base_by_error, :integer, null:false, default: 0, after: :double_play
  end

  def down
    remove_column :season_batter_records, :on_base_by_error
  end
end
