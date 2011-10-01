module ALasOcho::EventProxyExtensions
  def host=(user)
    new(email: user.email, user: user, state: "confirmed")
  end
end
