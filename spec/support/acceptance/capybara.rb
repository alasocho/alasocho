require "capybara/rails"
require "capybara-webkit"

Capybara.javascript_driver = :webkit

module ALasOcho::SpecHelpers::CapybaraHelpers
  def reload
    visit current_url
  end
end

RSpec.configure do |config|
  config.include Capybara::DSL, type: :acceptance
  config.include ALasOcho::SpecHelpers::CapybaraHelpers, type: :acceptance
end
