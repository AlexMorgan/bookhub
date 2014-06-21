class UsersController < ApplicationController
  def index
    @users = User.all.order(username: :asc)
  end

  def show
    @user = current_user
  end
end
