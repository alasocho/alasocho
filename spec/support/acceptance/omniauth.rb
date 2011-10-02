# TODO: This file might need to be moved to spec/support/integration so we can
# actually test User/Authorization integration, but not doing it until we need
# it for real :)

OmniAuth.configure do |config|
  config.test_mode = true
  config.add_mock(:google, uid: "john.host@example.com")
  config.add_mock(:google, uid: "john.invited@example.com")
end
