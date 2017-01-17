class CreateTotalBatterRecords < ActiveRecord::Migration
  def change
    create_table :total_batter_records do |t|
      t.integer :player_id, null:false, index: true
      t.integer :year, null:false, index: true
      t.integer :played_game, null:false, default: 0
      t.integer :plate_appearence, null:false, default: 0
      t.integer :at_bat, null:false, default: 0
      t.integer :total_hits, null:false, default: 0
      t.integer :one_base_hit, null:false, default: 0
      t.integer :two_base_hit, null:false, default: 0
      t.integer :three_base_hit, null:false, default: 0
      t.integer :home_run, null:false, default: 0
      t.integer :strike_out, null:false, default: 0
      t.integer :base_on_ball, null:false, default: 0
      t.integer :hit_by_pitched_ball, null:false, default: 0
      t.integer :rbi, null:false, default: 0
      t.integer :run, null:false, default: 0
      t.integer :steal, null:false, default: 0
      t.integer :steal_caught, null:false, default: 0
      t.decimal :batting_average, null:false, default: 0.0, precision: 4, scale: 3
      t.decimal :on_base_percentage, null:false, default: 0.0, precision: 4, scale: 3
      t.decimal :slugging_percentage, null:false, default: 0.0, precision: 4, scale: 3
      t.decimal :ops, null:false, default: 0.0, precision: 4, scale: 3
      t.boolean :is_regular_plate_appearance_satisfied, null:false, default: false

      t.timestamps null: false
    end
  end
end
