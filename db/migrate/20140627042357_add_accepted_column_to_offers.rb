class AddAcceptedColumnToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :accepted, :boolean, default: false
  end
end
