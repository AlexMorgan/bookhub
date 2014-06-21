class Book < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validates :quality, presence: true
  validates_formatting_of :course_title, :using => :alphanum

  def self.quality
    %w(New Good Decent )
  end
end
