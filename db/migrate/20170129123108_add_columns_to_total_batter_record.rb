class AddColumnsToTotalBatterRecord < ActiveRecord::Migration
 def up
    add_column :total_batter_records, :sacrifice_hit, :integer, null:false, default: 0, after: :is_regular_plate_appearance_satisfied
    add_column :total_batter_records, :sacrifice_fly, :integer, null:false, default: 0, after: :sacrifice_hit
    add_column :total_batter_records, :double_play, :integer, null:false, default: 0, after: :sacrifice_fly
    add_column :total_batter_records, :on_base_by_error, :integer, null:false, default: 0, after: :double_play
  end

  def down
    remove_column :total_batter_records, :sacrifice_hit
    remove_column :total_batter_records, :sacrifice_fly
    remove_column :total_batter_records, :double_play
    remove_column :total_batter_records, :on_base_by_error
  end
end
