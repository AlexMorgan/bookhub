class Book < ActiveRecord::Base
  belongs_to :user
  has_many :offers, dependent: :destroy

  validates :title, presence: true
  validates :quality, presence: true
  validates_formatting_of :course_title, using: :alphanum
  validates :price, numericality: { only_integer: true }, length: { maximum: 3 }
  validates :isbn, isbn_format: { with: :isbn10 },  uniqueness: { scope: :user_id, message: "You have already added this book" }
  validates :isbn13, :isbn_format => { with: :isbn13 }

  before_create :format_title

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

  def purchase(user, offer)
    @purchase = Purchase.new(user, offer)
  end

  protected

  def format_title
    lowercase = %w(a an the for and nor but or yet so at by after along from of on to with is)
    title = self.title.split
    arr = []
    title.each do |word|
      if lowercase.include?(word)
        arr << word.downcase
      else
        arr << word.capitalize
      end
    end
    if arr != []
      arr.first.capitalize!
      arr.last.capitalize!
      title = arr.join(' ')
      binding.pry
      self.title = title
    end
  end
end
