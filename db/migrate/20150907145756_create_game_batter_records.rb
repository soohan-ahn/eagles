class CreateGameBatterRecords < ActiveRecord::Migration
  def change
    create_table :game_batter_records do |t|
      t.integer :player_id, null:false
      t.integer :game_id, null:false
      t.integer :batting_order, null:false
      t.string :position, null: false, default: "D"
      t.integer :inning, null: false
      t.integer :at_plate_order, null: false
      t.integer :result_code

      t.timestamps null: false
    end
  end
end
