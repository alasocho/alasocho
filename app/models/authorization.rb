class Authorization < ActiveRecord::Base
  attr_accessible :provider, :key

  belongs_to :user

  PROVIDERS = %w(twitter facebook)

  def self.find_from_auth(auth)
    find_by_provider_and_key(auth.fetch("provider"), auth.fetch("uid"))
  end

  def self.create_from_auth(auth, user=nil)
    transaction do
      user ||= User.create_from_auth!(auth)
      user.authorizations.create(
        provider: auth.fetch("provider"),
        key:      auth.fetch("uid")
      )
    end
  end
end
