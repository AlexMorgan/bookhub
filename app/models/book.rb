class Book < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validates :quality, presence: true
  validates_formatting_of :course_title, using: :alphanum
  validates_formatting_of :price, using: :dollars, allow_nil: true
  validates :isbn, isbn_format: { with: :isbn10 },  uniqueness: { scope: :user_id, message: "You have already added this book" }
  validates :isbn13, :isbn_format => { with: :isbn13 }


  def self.qualities
    %w(New Good Decent )
  end

  def course_title
    super.split.map! {|word| word.upcase }.join(' ')
  end

  def price
    super.to_f.round(0)
  end

  def set_author(arg)
    if arg.nil?
      self.author = nil
    elsif arg[0..2] == "by "
      author = arg[3..-1]
      if arg[-2..-1] == ", "
        author = arg[0..-3]
      end
      self.author = arg
    else
      self.author = arg[0..-3]
    end
  end

end
