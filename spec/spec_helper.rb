require "rspec"

module ALasOcho
  module SpecHelpers
    module Unit; end
    module Functional; end
    module Acceptance; end
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

  module FunctionalSpecs
    def self.included(example_group)
      example_group.metadata[:type] = :functional
    end
  end

  module UnitSpecs
    def self.included(example_group)
      example_group.metadata[:type] = :unit
    end
  end

  config.include AcceptanceSpecs, example_group: {
    file_path: %r(spec/acceptance)
  }

  config.include FunctionalSpecs, example_group: {
    file_path: %r(spec/functional)
  }

  config.include UnitSpecs, example_group: {
    file_path: %r(spec/unit)
  }
end
