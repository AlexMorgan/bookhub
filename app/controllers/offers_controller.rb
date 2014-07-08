class OffersController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @offer = Offer.new(offer_params)
    if @offer.save
      UserMailer.offer_email(@book.user, current_user, @book, @offer).deliver
      redirect_to book_path(@book)
      flash[:notice] = "The seller has been notified of your offer! Thank You!"
    else
      render "books/show"
    end
  end

  def destroy
    @offer = Offer.find(params[:id]).destroy

    flash[:notice] = " Your offer for #{@offer.book.title} has been deleted."
    redirect_to user_path(current_user)
  end

  def accept
    @offer = Offer.find(params[:id])
    @offer.accepted = true
    @offer.save
    binding.pry

    @book = @offer.book
    @book.price = @offer.amount
    @book.buyer = @offer.user
    @book.sold = true
    @book.save

    UserMailer.accept_offer_email(current_user, @offer).deliver

    flash[:notice] = "#{@book.title} has been marked as purchased. The buyer has been notified"
    redirect_to user_path(current_user)
  end

  private

  def offer_params
    params.require(:offer).permit(:amount).merge({ user: current_user, book: @book })
  end
end
