class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :quality, null: false
      t.string :course_title, null: false
      t.integer :price
      t.string :isbn
      t.integer :user_id

      t.timestamps
    end
  end
end
