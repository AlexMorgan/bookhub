class CreateNeeds < ActiveRecord::Migration
  def change
    create_table :needs do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.string :isbn
      t.string :isbn13
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
