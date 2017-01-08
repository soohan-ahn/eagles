class ChangeColumnToAtBatBatterRecord < ActiveRecord::Migration
  def up
  	change_column :at_bat_batter_records, :result_code, :string, null: false
  end

  def down
  	change_column :at_bat_batter_records, :result_code, :integer, null: true
  end
end
