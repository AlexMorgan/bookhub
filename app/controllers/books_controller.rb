class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :search]
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
    @book.user_id = current_user.id

    if @book.save
      redirect_to books_path, notice: "#{@book.title} has been put up for sale"
    else
      render action: 'new'
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(book_params)
      # Same as redirect_to action: 'show', id: => @question
      redirect_to book_path
    else
      flash[:notice] = "Something went wrong!"
      render :new
    end
  end

  def search
    query = "%#{params[:query]}%"
    @books = Book
      .where('title like ? or course_title like ?',
             query, query)
  end

  def destroy
    Book.find(params[:id]).destroy

    flash[:notice] = "Book has been deleted"
    redirect_to user_path(current_user)
  end

  private

  def book_params
    params.require(:book).permit(:title, :quality, :course_title, :price)
  end
end
