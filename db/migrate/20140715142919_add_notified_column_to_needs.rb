class AddNotifiedColumnToNeeds < ActiveRecord::Migration
  def change
    add_column :needs, :notified, :boolean, default: false
  end
end
