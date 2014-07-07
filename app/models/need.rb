class Need < ActiveRecord::Base
  belongs_to :user

  validates_formatting_of :title, using: :alphanum, presence: true
  validates_formatting_of :author, using: :alpha, presence: true
  validates :isbn, isbn_format: { with: :isbn10 }, allow_nil: true
end
