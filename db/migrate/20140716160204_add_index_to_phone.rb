class AddIndexToPhone < ActiveRecord::Migration
  def change
    add_index :users, :phone, unique: true
  end
end
