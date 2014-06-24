class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :search]
  before_action :correct_user, only: [:edit, :update, :destroy]
  def index
    @page = params[:page].to_i
    @for_sale = Book.all.where(sold: 'false')
    @books = Book.all.order(created_at: :desc).limit(10).offset(10 * @page)
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
    @book = current_user.books.build(book_params)
    # Override book title with the formatted title
    @book.title = format_title(params[:book][:title])
    # Query book from API
    find_book_in_db(@book.title)

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
    @page = params[:page].to_i
    @for_sale = Book.where('title ilike ? or course_title ilike ? or isbn ilike ? or isbn13 ilike ? or author ilike ?',
             query, query, query, query, query)
    @books = @for_sale.order(created_at: :desc).limit(10).offset(10 * @page)
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
    Book.find(params[:id]).destroy

    flash[:notice] = "Book has been deleted"
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

    arr.first.capitalize!
    arr.last.capitalize!
    arr.join(' ')
  end

  def find_book_in_db(title)
    @query = ISBNdb::Query.find_book_by_title(title)
    if @query.first != nil
      @book.isbn = @query.first.isbn
      @book.isbn13 = @query.first.isbn13
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
