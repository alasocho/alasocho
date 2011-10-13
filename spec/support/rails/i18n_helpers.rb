module ALasOcho::SpecHelpers::I18n
  def t(key, options={})
    ::I18n.t(key, options)
  end
end

RSpec.configure do |config|
  config.include ALasOcho::SpecHelpers::I18n
end
