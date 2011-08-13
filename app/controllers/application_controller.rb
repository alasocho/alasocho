class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :signed_in?

  private

  def signed_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def current_user=(user)
    if user.respond_to?(:persisted?) && user.persisted?
      session[:user_id] = user.id
      @current_user = user
    end
  end
end
