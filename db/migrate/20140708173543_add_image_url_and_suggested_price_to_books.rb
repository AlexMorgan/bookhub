class AddImageUrlAndSuggestedPriceToBooks < ActiveRecord::Migration
  def change
    add_column :books, :image_url, :string
    add_column :books, :used_price, :integer
    add_column :books, :new_price, :integer
    add_column :books, :amazon_url, :string
  end
end
