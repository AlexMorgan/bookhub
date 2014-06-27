class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.integer :user_id, null: false
      t.integer :book_id, null: false
      t.integer :amount, null: false

      t.timestamps
    end

    add_index :offers, [:user_id, :book_id], unique: true
  end
end
