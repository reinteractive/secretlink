source 'https://rubygems.org'

ruby File.read(File.join(File.dirname(__FILE__), '.ruby-version')).strip

gem 'rails', '~> 4.2.5'

gem 'attr_encrypted'
gem 'bootstrap-sass', '~> 3.3.4'
gem 'carrierwave'
gem 'email_validator'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'omniauth-google-oauth2'
gem 'pg'
gem 'pickadate-rails'
gem 'sass-rails', '>= 3.2'
gem 'simple_form'
gem 'logstasher', '~> 0.6.5'
gem 'uglifier'
gem 'unicorn'
gem 'unicorn-rails'
gem 'ops_care', :git => 'git@github.com:reinteractive/OpsCare.git', :branch => 'master'

group :development do
  gem 'better_errors'
  gem 'quiet_assets'
  gem 'rubocop'
  gem 'foreman'
end

group :test do
  gem 'byebug'
  gem 'capybara'
  gem 'poltergeist'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'faker'
  gem 'launchy'
  gem 'show_me_the_cookies', '~> 3.1.0'
end

group :development, :test do
  gem 'pry'
  gem 'dotenv-rails'
end
