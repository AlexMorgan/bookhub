class OffersController < ApplicationController
  def create
    @offer = Offer.new(offer_params)
    @book = Book.find(params[:book_id])
    @offer.book = @book
    if @offer.save
      redirect_to book_path(@book)
      flash[:notice] = "The seller has been notified of your offer! Thank You!"
    else
      render :new
    end
  end

  private

  def offer_params
    params.require(:offer).permit(:amount).merge(user: current_user)
  end
end
