class Offer < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  validates :user_id, presence: true
  validates :book_id, uniqueness: { scope: :user_id, message: "You have already made an offer for this book" }, presence: true
  validates :amount, numericality: { only_integer: true }, length: { maximum: 3 }, presence: true
end
