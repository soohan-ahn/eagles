class CreateUser < ActiveRecord::Migration
  def up
    create_table :users do |t|
    	t.string :email, null:false
    	t.string :password_hash, null:false
    	t.boolean :is_admin, default: false
    end
  end

  def down
    drop_table :users
  end
end
