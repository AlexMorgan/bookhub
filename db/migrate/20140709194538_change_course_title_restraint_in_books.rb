class ChangeCourseTitleRestraintInBooks < ActiveRecord::Migration
  def up
    change_column :books, :course_title, :string, null: true
  end

  def down
    change_column :books, :course_title, :string, null: false
  end
end
