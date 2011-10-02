module ALasOcho::SpecHelpers::Sessions
  def self.included(example_group)
    example_group.fixtures :users
  end

  attr :current_user

  def sign_in(user)
    @current_user = User === user ? user : users(user)
    auth = @current_user.authorizations.first
    visit "/auth/#{auth.provider}"
  end

  def sign_out
    visit "/auth/sign_out"
  end
end

RSpec.configure do |config|
  config.include ALasOcho::SpecHelpers::Sessions
end
