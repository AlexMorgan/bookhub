class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :destroy]
  def index
    @books = Book.all.order(created_at: :desc)

    ##Location-based books
    # users = User.all.near(current_user, 15)
    # @books = []
    # users.each do |user|
    #   user.books.each do |book|
    #     @books << book
    #   end
    # end
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
      if @book.amazon_url.present?
        UpdateSearch.perform_async(@book.id)
        redirect_to edit_book_path(@book), notice: "Make sure this information is correct!"
      else
        @book.destroy
        redirect_to new_book_path
        flash[:notice] = 'Book could not be found. Please try the ISBN'
      end
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
      flash[:notice] = "This page does not exist"
      redirect_to books_path
    end
  end

  def book_params
    params.require(:book).permit(:title, :quality, :course_title, :price, :isbn, :isbn13, :author, :image_url, :used_price, :new_price, :amazon_url)
  end
end
