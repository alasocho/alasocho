require "rspec"

module ALasOcho
  module SpecHelpers
  end
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.treat_symbols_as_metadata_keys_with_true_values = true

  module AcceptanceSpecs
    def self.included(example_group)
      example_group.metadata[:type] = :acceptance
    end
  end

  config.include AcceptanceSpecs, example_group: {
    file_path: %r(spec/acceptance)
  }
end
