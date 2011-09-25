require "rspec"

$LOAD_PATH.unshift("./app/models")

Dir["./spec/support/unit/**/*.rb"].each {|f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
