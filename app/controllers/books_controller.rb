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
    @book = current_user.books.build(book_params)

    @query = ISBNdb::Query.find_book_by_title(@book.title)
    @book.isbn = @query.first.isbn
    @book.isbn13 = @query.first.isbn13
    author = @query.first.authors_text
    if author[0..2] == "by "
      author = author[3..-1]
      if author[-2..-1] == ", "
        author = author[0..-3]
      end
      @book.author = author
    elsif author[-2..-1] == ", "
      author = author[0..-3]
      @book.author = author
    end

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
    Book.find(params[:id]).destroy

    flash[:notice] = "Book has been deleted"
    redirect_to user_path(current_user)
  end

  private

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
