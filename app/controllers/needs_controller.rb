class NeedsController < ApplicationController
  def new
    @need = Need.new
  end

  def create
    @need = Need.new(need_params)

    if @need.save
      flash[:notice] = "#{@need.title} has been added to your wishlist"
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  private

  def need_params
    params.require(:need).permit(:title, :isbn, :isbn13, :author).merge(user: current_user)
  end
end
