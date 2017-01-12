class ChangeColumnToGames < ActiveRecord::Migration
  def up
  	add_column :games, :league_id, :integer, null:false, default: 1, after: :game_type
  	add_column :games, :ground_id, :integer, null:false, default: 1, after: :league_id
  	remove_column :games, :league
  end

  def down
  	remove_column :games, :league_id
  	remove_column :games, :ground_id
  	add_column :games, :league, :string, null:false, default: "Exchibition", after: :score_box
  end
end
