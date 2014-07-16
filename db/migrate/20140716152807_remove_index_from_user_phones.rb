class RemoveIndexFromUserPhones < ActiveRecord::Migration
  def change
    remove_index :users, :phone
  end
end
