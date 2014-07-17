class NeedsController < ApplicationController
  def new
    @need = Need.new
  end

  def create
    @need = Need.new(need_params)

    if @need.save
      WishlistWorker.perform_async(@need.id)
      flash[:notice] = "#{@need.title} has been added to your wishlist"
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def destroy
    @need = Need.find(params[:id]).destroy

    flash[:notice] = "#{@need.title} has been removed from your wishlist"
    redirect_to user_path(current_user)
  end

  private

  def need_params
    params.require(:need).permit(:title, :isbn, :isbn13, :author).merge(user: current_user)
  end
end
