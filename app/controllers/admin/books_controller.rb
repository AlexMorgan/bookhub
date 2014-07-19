class Admin::BooksController < ApplicationController
  before_action :check_admin

  def index
    @books = Book.all
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])

    if @book.update(book_params)
      flash[:notice] = "#{@book.title} has been successfully updated"
      redirect_to admin_books_path
    else
      flash[:notice] = "There were errors in your submission"
      render :admin_edit
    end
  end

  def destroy
    @book = Book.find(params[:id]).destroy

    flash[:notice] = "#{@book.title} has been deleted."
    redirect_to admin_books_path
  end

  protected
  def check_admin
    if !current_user.admin?
      flash[:notice] = "This page does not exist"
      redirect_to root_path
    end
  end

  def book_params
    params.require(:book).permit(:title, :isbn, :isbn13, :author, :image_url, :amazon_url)
  end
end
