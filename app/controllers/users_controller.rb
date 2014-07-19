class UsersController < ApplicationController
  before_action :authenticate_admin, only: [:index]
  def index
    @users = User.all.order(username: :asc)
  end

  def show
    @user = current_user
    @recent_activities = Book.order(created_at: :desc).limit(3)
    sql = "SELECT count(offers.id) FROM offers JOIN books
          ON offers.book_id = books.id JOIN users ON users.id = books.user_id
          WHERE users.id = #{@user.id} AND books.sold = false;"

    @offer_count = ActiveRecord::Base.connection.execute(sql)
    @offer_count = @offer_count.first["count"]
  end

  private
    def authenticate_admin
      if !current_user.admin?
        flash[:notice] = "This page does not exist"
        redirect_to user_path(current_user)
      end
    end
end
