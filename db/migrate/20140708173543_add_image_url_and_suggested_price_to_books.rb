class AddImageUrlAndSuggestedPriceToBooks < ActiveRecord::Migration
  def change
    add_column :books, :image_url, :string
    add_column :books, :suggested_price, :integer
  end
end
