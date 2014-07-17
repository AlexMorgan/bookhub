class Book < ActiveRecord::Base
  belongs_to :user
  belongs_to :buyer, class_name: "User"
  has_many :offers, dependent: :destroy

  validates :title, presence: true,
    if: Proc.new { |book| book.isbn13.blank? }
  validates :quality, presence: true
  validates_formatting_of :course_title, using: :alphanum, allow_blank: true
  validates :price, numericality: { only_integer: true }, length: { maximum: 3 }
  validates :isbn,
    isbn_format: { with: :isbn },
    uniqueness: { scope: :user_id, message: "You have already added this book" },
    allow_blank: true

  validates :isbn13,
    isbn_format: { with: :isbn13 },
    presence: true,
    if: Proc.new { |book| book.title.blank? },
    uniqueness: { scope: :user_id, message: "You have already added this book" }

  before_validation :format_title, :find_book_in_db

  def self.qualities
    %w(New Good Decent )
  end

  def self.book_count(user_id)
    user_books = Book.all.where(sold: :false, user_id: user_id).count
    library = Book.all.where(sold: :false).count
    library - user_books
  end

  def course_title
    super.split.map! {|word| word.upcase }.join(' ') unless super.blank?
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


  def short_title(title)
    if title.length > 20
      "#{title[0..20]}.."
    else
      title
    end
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
      self.title = title
    end
  end

  def convert_to_isbn13
    if self.isbn.present?
      isbn = "978" + self.isbn
      isbn_10 = isbn[0..11].split('')
      isbn_13 = nil

      sum = 0
      counter = 0
      isbn_10.each do |n|
        if counter%2 == 1
            sum += n.to_i * 3
            counter += 1
        else
          sum += n.to_i
          counter += 1
        end
      end

      remainder = sum%10

      if remainder == 0
        check_digit = 0
      else
        check_digit = 10 - remainder
      end

      self.isbn13 = isbn_10.join('') + check_digit.to_s
    end
  end

  def find_book_in_db
    client = ASIN::Client.instance

    # If user doesn't add by title they can add by isbn13
    if self.title.length == 0
      query = client.search_keywords(self.isbn13).first
    else
      query = client.search_keywords(self.title).first
    end
    # Test to make sure we get a result form Amazon
    if query != nil
      attributes = query.item_attributes
      self.title = attributes.title if self.title == ''
      # Test for ISBN-10 or ISBN-13
      if attributes.isbn.length == 10
        self.isbn = attributes.isbn
        if self.isbn13 == ""
          convert_to_isbn13
        end
      else
        if self.isbn13 == ""
          self.isbn13 = attributes.isbn
        end
      end

      # Test for whether there are multiple authors
      if attributes.author.kind_of?(Array)
        authors = ""
        attributes.author.each_with_index { |author, index|
          if index == 0
            authors << author
          else
          authors << ", #{author}"
          end
        }
        self.author = authors
      else
        self.author = attributes.author
      end

      self.image_url = query.large_image.url
      self.amazon_url = query.detail_page_url
      self.used_price = format_suggested_price(query.offer_summary.lowest_used_price.amount)
      self.new_price = format_suggested_price(query.offer_summary.lowest_new_price.amount)
    end
  end

  def format_suggested_price(price)
    (price.to_f / 100).round
  end

end
