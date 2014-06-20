class AddPersonalInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :year, :string
    add_column :users, :phone, :string

    add_index :users, :phone, unique: true
  end
end
