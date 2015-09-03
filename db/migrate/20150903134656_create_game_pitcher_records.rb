class CreateGamePitcherRecords < ActiveRecord::Migration
  def change
    create_table :game_pitcher_records do |t|
      t.integer :player_id, null:false
      t.integer :game_id, null:false
      t.string :pitched_order, null:false
      t.boolean :win
      t.boolean :lose
      t.boolean :save
      t.boolean :hold
      t.float :innings_pitched, null:false, default: 0
      t.integer :plate_appearance, null:false, default: 0
      t.integer :at_bat, null:false, default: 0
      t.integer :hit, null:false, default: 0
      t.integer :homerun, null:false, default: 0
      t.integer :sacrifice_bunt, null:false, default: 0
      t.integer :sacrifice_fly, null:false, default: 0
      t.integer :run, null:false, default: 0
      t.integer :earned_run, null:false, default: 0
      t.integer :strike_out, null:false, default: 0
      t.integer :walk, null:false, default: 0
      t.integer :intentional_walk, null:false, default: 0
      t.integer :hit_by_pitch, null:false, default: 0
      t.integer :wild_pitch, null:false, default: 0
      t.integer :balk, null:false, default: 0
      t.integer :number_of_pitches, null:false, default: 0

      t.timestamps null: false
    end
  end
end
