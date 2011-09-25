require "integration_spec_helper"
require "capybara/rails"

Capybara.javascript_driver = :webkit

Dir["./spec/support/acceptance/**/*.rb"].each {|f| require f }
