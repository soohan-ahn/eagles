class AddColumnGameType < ActiveRecord::Migration
	def up
    add_column :games, :game_type, :integer, null:false, default: 0
  end

  def down
    remove_column :games, :game_type, :integer
  end
end
