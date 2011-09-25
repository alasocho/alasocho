module ALasOcho::SpecHelpers::Sessions
  def self.included(example_group)
    example_group.fixtures :users
  end

  def sign_in(user)
    user = User === user ? user : users(user)
    auth = user.authorizations.first
    visit "/auth/#{auth.provider}"
  end

  def sign_out
    visit "/auth/sign_out"
  end
end

RSpec.configure do |config|
  config.include ALasOcho::SpecHelpers::Sessions
end
