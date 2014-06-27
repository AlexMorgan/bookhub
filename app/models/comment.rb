class Comment < ActiveRecord::Base
  belongs_to :book
  belongs_to :user

  validates :user_id, presence: true
  validates :body, presence: true
end
