class Offer < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  validates :user_id, presence: true
  validates :book_id, presence: true
  validates_formatting_of :amount, using: :dollars, allow_nil: false
end
