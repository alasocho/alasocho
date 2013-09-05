class SessionsController < ApplicationController
  def create
    auth_hash = request.env.fetch("omniauth.auth")

    authorization = Authorization.find_from_auth(auth_hash)

    if signed_in? && authorization.present? && authorization.user != current_user # Another user is already using that one => let him merge
      session[:authorized_user_id] = authorization.user.id
      redirect_to new_account_merge_path
    else # Normal flow, either create new current_user or login, or join account
      authorization ||= Authorization.create_from_auth(auth_hash, current_user)

      self.current_user = authorization.user

      redirect_to request.env['omniauth.origin'] || '/'
    end
  end

  def destroy
    self.current_user = nil
    session.clear

    redirect_to root_path, notice: t("sessions.sign_out.success")
  end
end
