# This replicates RSpec's setup for request specs, so we get integration helpers
# from rails, and thus can use routes and some rails-specific matchers inside
# acceptance tests.
RSpec.configure do |config|
  config.include RSpec::Rails::SetupAndTeardownAdapter, type: :acceptance
  config.include RSpec::Rails::TestUnitAssertionAdapter, type: :acceptance
  config.include ActionDispatch::Integration::Runner, type: :acceptance
  config.include ActionDispatch::Assertions, type: :acceptance
  config.include RSpec::Rails::Matchers::RedirectTo, type: :acceptance
  config.include RSpec::Rails::Matchers::RenderTemplate, type: :acceptance
  config.include ActionController::TemplateAssertions, type: :acceptance

  # FIXME: Investigate why we can't use the same thing we use for functional
  # specs in here :-/
  config.include Module.new { def app; ::Rails.application; end }, type: :acceptance

  config.before do
    @routes = ::Rails.application.routes
  end
end
