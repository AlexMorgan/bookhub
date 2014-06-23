class AddColumnDataToBooks < ActiveRecord::Migration
  def change
    add_column :books, :isbn13, :string
    add_column :books, :author, :string
  end
end
