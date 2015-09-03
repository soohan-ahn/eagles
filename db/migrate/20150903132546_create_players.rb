class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name, null: false
      t.date :birth
      t.string :team
      t.string :back_number
      t.string :bats
      t.string :throws

      t.timestamps null: false
    end
  end
end
