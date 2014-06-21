class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
  end

  def new
  end

  def create
  end

  private

  def book_params
    params.require(:book).permit(:title, :quality, :course_title, :price)
  end
end
