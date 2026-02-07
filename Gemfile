source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.8'

gem 'dotenv-rails', groups: [:development, :test]

# Rails 8.1 Framework
gem 'rails', '~> 8.1', '>= 8.1.2'

# Use Puma as the app server
gem 'puma', '~> 6.4', '>= 6.4.2'

# ActiveResource is your primary data layer (replaces ActiveRecord)
gem 'activeresource'

# --- DATABASE GEMS REMOVED ---
# 'pg' gem has been removed as we are not using PostgreSQL.
# -----------------------------

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'observer'
  gem 'rspec-rails', '~> 7.0' # Updated for Rails 8 compatibility
  gem 'simplecov'
  gem 'simplecov-console'
end

group :development do
  gem 'listen', '>= 3.0.5'
end

# Windows compatibility
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :test do
  gem 'factory_bot_rails'
  gem 'shoulda-matchers', '~> 6.0' # Updated for Rails 8 compatibility
  gem 'faker'
  gem 'webmock'
end

# Infrastructure and Monitoring
gem "health_check"

group :production do
  gem 'newrelic_rpm'
end

# Cors
gem 'rack-cors', '~> 3.0'
