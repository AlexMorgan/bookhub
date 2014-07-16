class RemoveIndexFromUserPhones < ActiveRecord::Migration
  def up
    remove_index :users, :phone
  end

  def down
    add_index :users, :phone, unique: true
  end
end
