class Need < ActiveRecord::Base
  belongs_to :user

  validates_formatting_of :title, using: :alphanum, presence: true
  validates :author, presence: true
  validates :isbn, isbn_format: true, allow_blank: true
  validates :isbn13, isbn_format: { with: :isbn10 }, allow_nil: true
  validates :user_id, presence: true
end
