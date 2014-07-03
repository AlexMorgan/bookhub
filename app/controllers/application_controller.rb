class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: :home
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    sign_in_url = url_for(:action => 'new', :controller => 'sessions', :only_path => false, :protocol => 'http')
    if resource.sign_in_count == 1
      flash[:notice] = "Welcome to BookHub. Please complete your profile!"
      edit_user_registration_path
    else
      user_path(current_user)
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:username, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:username, :password, :password_confirmation, :avatar, :address, :firstname, :lastname, :phone, :year, :current_password)
    end
  end
end
