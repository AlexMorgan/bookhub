class BookCreationService
  def initialize(user, book_attrs)
    @user = user
    @book_attrs = book_attrs
  end

  def build_book
    query = find_book_in_db(@book_attrs[:title])

    query_attrs = {
      isbn: query.isbn,
      isbn13: convert_to_isbn13(query.isbn),
      author: query.authors_text
    }

    @book = @user.books.build(@book_attrs.merge(query_attrs))

    @book
  end

  def format_title(title)
    lowercase = %w(a an the for and nor but or yet so at by after along from of on to with is)
    title = title.split
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
    end
  end

  def convert_to_isbn13(isbn)
    isbn= "978" + isbn
    isbn_10 = isbn[0..11].split('')
    isbn_13 = nil

    sum = 0
    counter = 0
    isbn_10.each do |n|
      if counter % 2 == 1
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

    isbn_13 = isbn_10.join('') + check_digit.to_s
  end

  def find_book_in_db(title)
    query = ISBNdb::Query.find_book_by_title(title)

    query.first
  end
end
