class CreateGameFielderSimpleRecords < ActiveRecord::Migration
	def change
    create_table :game_fielder_simple_records do |t|
      t.integer :player_id, null:false
      t.integer :game_id, null:false
      t.integer :field_error, null:false

      t.timestamps null: false
    end
  end
end
