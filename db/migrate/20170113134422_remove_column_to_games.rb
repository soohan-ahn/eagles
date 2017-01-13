class RemoveColumnToGames < ActiveRecord::Migration
  def up
    remove_column :games, :stadium
    remove_column :games, :game_type
  end

  def down
    t.string :stadium
    add_column :games, :stadium, :string, after: :away_score
    add_column :games, :game_type, :integer, null:false, default: 0, after: :updated_at
  end
end
