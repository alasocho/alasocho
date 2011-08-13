require "omniauth/oauth"

Rails.application.config.middleware.use OmniAuth::Builder do
  twitter_config  = ALasOcho.config.fetch(:twitter, {})
  facebook_config = ALasOcho.config.fetch(:facebook, {})

  provider :twitter, twitter_config.fetch(:consumer_key),
                     twitter_config.fetch(:consumer_secret)
  provider :facebook, facebook_config.fetch(:api_key),
                      facebook_config.fetch(:api_secret)
end
