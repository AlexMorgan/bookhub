class NeedsController < ApplicationController
  def show
  end

  def new
  end

  def create
  end

  private

  def need_params
    params.require(:need).permit(:title, :quality, :course_title, :price, :isbn, :isbn13, :author)
  end
end
