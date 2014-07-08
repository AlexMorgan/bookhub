class AddBuyerIdToBooks < ActiveRecord::Migration
  def change
    add_column :books, :buyer_id, :integer, default: nil
  end
end
