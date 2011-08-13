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

  def authenticate_user
    unless signed_in?
      session[:wants_page] = request.path
      redirect_to root_path, :alert => I18n.t("flash.need_to_sign_in")
    end
  end
end
