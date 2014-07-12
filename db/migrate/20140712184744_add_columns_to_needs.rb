class AddColumnsToNeeds < ActiveRecord::Migration
  def change
    add_column :needs, :image_url, :string
    add_column :needs, :amazon_url, :string
  end
end
