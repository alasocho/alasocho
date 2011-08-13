class SessionsController < ApplicationController
  def create
    auth_hash = request.env.fetch("omniauth.auth")

    authorization = Authorization.find_from_auth(auth_hash)
    authorization ||= Authorization.create_from_auth(auth_hash, current_user)

    self.current_user = authorization.user

    redirect_to root_path, notice: t("sessions.sign_in.success")
  end

  def destroy
    self.current_user = nil
    session.clear

    redirect_to root_path, notice: t("sessions.sign_out.success")
  end
end
