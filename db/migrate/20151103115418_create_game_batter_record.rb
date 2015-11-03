class CreateGameBatterRecord < ActiveRecord::Migration
  def up
    create_table :game_batter_records do |t|
      t.integer :player_id, null:false
      t.integer :game_id, null:false
      t.integer :rbi, null:false, default: 0
      t.integer :run, null:false, default: 0
      t.integer :steal, null:false, default: 0
      t.integer :steal_caught, null:false, default: 0

      t.timestamps null: false
    end
  end

  def down
    drop_table :game_batter_records
  end
end
