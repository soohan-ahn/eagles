class CreateTotalPitcherRecords < ActiveRecord::Migration
  def change
    create_table :total_pitcher_records do |t|
      t.integer :player_id, null:false, index: true
      t.integer :year, null:false, index: true
      t.integer :pitched_games, null:false, default:0
      t.integer :win, null:false, default:0
      t.integer :lose, null:false, default:0
      t.decimal :era, null:false, default:0.0, precision: 4, scale: 2
      t.float :inning_pitched, null:false, default:0.0
      t.integer :hit, null:false, default:0
      t.integer :run, null:false, default:0
      t.integer :earned_run, null:false, default:0
      t.integer :homerun, null:false, default:0
      t.integer :walk, null:false, default:0
      t.integer :strike_out, null:false, default:0
      t.integer :hit_by_pitch, null:false, default:0
      t.decimal :whip, null:false, default:0.0, precision: 4, scale: 2
      t.boolean :is_regular_inning_satisfied, null:false, default: false

      t.timestamps null: false
    end
  end
end
