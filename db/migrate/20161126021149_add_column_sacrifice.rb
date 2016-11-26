class AddColumnSacrifice < ActiveRecord::Migration
  def up
    add_column :season_batter_records, :sacrifice_hit, :integer, null:false, default: 0, after: :is_regular_plate_appearance_satisfied
    add_column :season_batter_records, :sacrifice_fly, :integer, null:false, default: 0, after: :sacrifice_hit
    add_column :season_batter_records, :double_play, :integer, null:false, default: 0, after: :sacrifice_fly
  end

  def down
    remove_column :season_batter_records, :sacrifice_hit
    remove_column :season_batter_records, :sacrifice_fly
    remove_column :season_batter_records, :double_play
  end
end
