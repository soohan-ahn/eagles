class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :home_team, null: false
      t.string :away_team, null: false
      t.integer :home_score, null: false, default: 0
      t.integer :away_score, null: false, default: 0
      t.string :stadium
      t.string :score_box
      t.string :league, null: false, default: "Exchibition"
      t.datetime :game_start_time

      t.timestamps null: false
    end
  end
end
