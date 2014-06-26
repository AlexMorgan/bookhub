class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :search]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @books = Book.all.order(created_at: :desc)
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = current_user.books.build
  end

  def edit
    @book = Book.find(params[:id])
  end

  def create
    # @book = current_user.books.build(book_params)
    # Overwrite book title with the formatted title
    # @book.title = format_title(params[:book][:title])

    book_creation_service = BookCreationService.new(current_user, book_params)
    @book = book_creation_service.build_book

    # Query book from API
    # find_book_in_db(@book.title)

    # client = Openlibrary::Client.new

    # ########## Work in progress ###########
    # results = client.search(title: @book.title)
    # match = @book.title.downcase.split
    # runs = results.length
    # trials = match.length

    # match_outcome = nil
    # # The index of the result where the title matches
    # result_match = -1
    # catch (:match) do
    #   results.each do |result|
    #     result_match +=1
    #     outcome = []
    #     counter = 0
    #     while counter < trials do
    #       title = result.title.downcase.split
    #       title.each do |word|
    #         if word == match[counter]
    #           outcome << match[counter]
    #           counter += 1
    #           if outcome.length == trials
    #             match_outcome = outcome
    #             throw :match
    #           end
    #         else
    #           counter = trials
    #         end
    #       end
    #     end
    #   end
    # end
    # result_match
    # binding.pry
    # # Do logic to say if match_outcome is nil say "This is not a valid book,
    # #please make sure the title is spelled correctly"
    # title = match_outcome.join(' ')
    # format_title(title)

    if @book.save
      redirect_to books_path, notice: "#{@book.title} has been put up for sale"
    else
      render action: 'new'
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(book_params)
      redirect_to book_path
    else
      flash[:notice] = "Something went wrong!"
      render :new
    end
  end

  def search
    query = "%#{params[:query]}%"
    query.downcase
    @books = Book.where('title ilike ? or course_title ilike ? or isbn ilike ? or isbn13 ilike ? or author ilike ?',
             query, query, query, query, query)
  end

  def buy
    @book = Book.find(params[:id])
    @book.sold = true
    @book.save

    UserMailer.purchase_email(current_user, @book.user, @book).deliver

    flash[:notice] = "#{@book.title} has been marked as purchased. The Seller has been notified"
    redirect_to books_path
  end

  def destroy
    @book = Book.find(params[:id]).destroy

    flash[:notice] = "#{@book.title} has been deleted from your library"
    redirect_to user_path(current_user)
  end

  private

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
      if counter%2 == 1
          sum += n.to_i * 3
          counter += 1
      else
        sum += n.to_i
        counter += 1
      end
    end

    remainder = sum%10
    check_digit = 10 - remainder

    if check_digit == 0
      check_digit = 0
    else
      check_digit
    end

    isbn_13 = isbn_10.join('') + check_digit.to_s
  end

  def find_book_in_db(title)
    @query = ISBNdb::Query.find_book_by_title(title)
    if @query.first != nil
      @book.isbn = @query.first.isbn
      @book.isbn13 = convert_to_isbn13(@book.isbn)
      author = @query.first.authors_text
      @book.set_author(author)
    end
  end

  def correct_user
    @book = current_user.books.find_by(id: params[:id])
    if @book.nil?
      flash[:notice] = "You are not authorized to commit this crime!"
      redirect_to books_path
    end
  end

  def book_params
    params.require(:book).permit(:title, :quality, :course_title, :price, :isbn, :isbn13, :author)
  end
end
