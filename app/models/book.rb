class Book < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validates :quality, presence: true
  validates_formatting_of :course_title, using: :alphanum
  validates_formatting_of :price, using: :dollars, allow_nil: true

  def self.qualities
    %w(New Good Decent )
  end
end