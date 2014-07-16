class AddDefaultToUserPhone < ActiveRecord::Migration
  def up
    change_column :users, :phone, :string, default: nil
  end

  def down
    change_column :users, :phone, :string
  end
end
