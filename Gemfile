source "http://rubygems.org"

gem "rails", "~> 3.1.0"
gem "pg"
gem "oa-oauth"
gem 'haml'
gem 'micromachine'
gem 'rails-i18n'
gem 'resque'
gem 'resque-retry'
gem 'daemons'
gem 'postmark-rails'
gem 'hoptoad_notifier'
gem 'simple_uuid'
gem 'ri_cal'
gem 'bcrypt-ruby'

gem "jquery-rails"
gem "backbone-rails"

gem "nokogiri"

group :production do
  gem "unicorn"
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass-rails",   "~> 3.1.0"
  gem "coffee-rails", "~> 3.1.0"
  gem "uglifier"
end

group :test do
  gem "capybara"
  gem "launchy"
end

group :development, :test do
  gem "ruby-debug19"
  gem "rspec-rails", "~> 2.6"
end
