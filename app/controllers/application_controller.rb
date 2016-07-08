class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :sign_in, :sign_out, :signed_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out(user)
    session[:user_id] = nil
  end

  def signed_in?
    current_user.present?
  end
end
