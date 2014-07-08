class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :search]
  before_action :correct_user, only: [:edit, :destroy]
  def index
    @books = Book.all.order(created_at: :desc)
  end

  def show
    @book = Book.find(params[:id])
    @comment = Comment.new
    @offer = Offer.new
  end

  def new
    @book = current_user.books.build
  end

  def edit
    @book = Book.find(params[:id])
  end

  def create
    @book = current_user.books.build(book_params)

    if @book.save
      redirect_to edit_book_path(@book), notice: "Make sure this information is correct!"
    else
      render action: 'new'
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book)
    else
      flash[:notice] = "Something went wrong!"

      render :edit
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
    binding.pry
    @book.buyer = current_user
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

protected
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
