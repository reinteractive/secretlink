source "https://rubygems.org"

ruby File.read(File.join(File.dirname(__FILE__), ".ruby-version")).strip

gem "rails", "~> 4.2.8"

gem "attr_encrypted"
gem "bootstrap-sass", "~> 3.3.4"
gem "carrierwave"
gem "email_validator"
gem "jbuilder", "~> 2.0"
gem "jquery-rails"
gem "omniauth-google-oauth2"
gem "pg"
gem "pickadate-rails"
gem "sass-rails", "~> 5.0"
gem 'uglifier', '>= 1.3.0'
gem "simple_form"
gem "logstasher", "~> 0.6.5"
gem "unicorn"
gem "unicorn-rails"
gem "recaptcha"

gem "bugsnag"
gem "okcomputer"
gem "skylight"
gem 'rails_12factor', group: :production
gem "devise"

gem 'sdoc', '~> 0.4.0', group: :doc

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "quiet_assets"
  gem "rubocop"
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :test do
  gem "capybara"
  gem "poltergeist"
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem "database_cleaner"
  gem "faker"
  gem "launchy"
  gem "show_me_the_cookies", "~> 3.1.0"
end

group :development, :test do
  gem "byebug"
  gem "dotenv-rails"
  gem 'pry'
end
