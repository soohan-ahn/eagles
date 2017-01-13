class CreateGrounds < ActiveRecord::Migration
  def change
    create_table :grounds do |t|
      t.string :name, null: false
      t.integer :ground_type, null: false, default: 1
      t.integer :grass_type, null: false, default: 1

      t.timestamps null: false
    end
  end
end
