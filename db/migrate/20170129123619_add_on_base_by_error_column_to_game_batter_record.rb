class AddOnBaseByErrorColumnToGameBatterRecord < ActiveRecord::Migration
  def up
    add_column :game_batter_records, :on_base_by_error, :integer, null:false, default: 0, after: :sacrifice_fly
  end

  def down
    remove_column :game_batter_records, :on_base_by_error
  end
end
