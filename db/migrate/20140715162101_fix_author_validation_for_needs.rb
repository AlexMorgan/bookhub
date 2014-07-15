class FixAuthorValidationForNeeds < ActiveRecord::Migration
  def up
    change_column :needs, :author, :string, null: true
  end

  def down
    change_column :needs, :author, :string, null: false
  end
end
