source "https://rubygems.org"

ruby File.read(File.join(File.dirname(__FILE__), ".ruby-version")).strip

gem "rails", "~> 5.0.0"

gem "attr_encrypted"
gem "bootstrap-sass", "~> 3.3.4"
gem "bootstrap-scss"
gem "carrierwave"
gem "email_validator"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "omniauth-google-oauth2"
gem "pg"
gem "pickadate-rails"
gem 'uglifier', '>= 1.3.0'
gem "simple_form"
gem "logstasher", "~> 0.6.5"
gem 'puma', '~> 3.0'
gem "recaptcha"
gem "sassc-rails"

gem "bugsnag"
gem "okcomputer"
gem "skylight"
gem 'rails_12factor', group: :production

gem 'sdoc', '~> 0.4.0', group: :doc

group :development do
  gem "better_errors"
  gem "rubocop"
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem "capybara"
  gem "capybara-selenium"
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem "database_cleaner"
  gem "faker"
  gem "launchy"
  gem "show_me_the_cookies", '~> 5.0.1'
  gem "timecop"
end

group :development, :test do
  gem "byebug"
  gem "dotenv-rails"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
