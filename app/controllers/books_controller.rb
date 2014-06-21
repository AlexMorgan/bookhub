class BooksController < ApplicationController
  def index
    @books = Book.all.order(created_at: :desc)
  end

  def show
    @book = Book.find(params[:id])
    @owner = @book.user
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id

    if @book.save
      redirect_to books_path, notice: "#{@book.title} has been put up for sale"
    else
      render action: 'new'
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :quality, :course_title, :price)
  end
end
