class SessionsController < ApplicationController
  def create
    auth_hash = request.env.fetch("omniauth.auth")

    authorization = Authorization.find_from_auth(auth_hash)
    authorization ||= Authorization.create_from_auth(auth_hash, current_user)

    self.current_user = authorization.user

    render text: "Hola, #{current_user.name}"
  end
end
