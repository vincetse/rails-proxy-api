require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require 'uri'
# 1. Check for presence
if ENV['UPSTREAM_URL'].nil? || ENV['UPSTREAM_URL'].strip.empty?
  abort <<~ERROR

    =======================================================================
    FATAL: UPSTREAM_URL is not set!
    The RemoteResource models require this to build API paths.

    LOCAL: Add 'UPSTREAM_URL=http://localhost:3000' to your .env.test file.
    CI: Add 'UPSTREAM_URL' to your GitHub Actions secrets or env section.
    =======================================================================
  ERROR
end

# 2. Check for basic URI validity
begin
  uri = URI.parse(ENV['UPSTREAM_URL'])
  unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    abort "FATAL: UPSTREAM_URL '#{ENV['UPSTREAM_URL']}' must start with http:// or https://"
  end
rescue URI::InvalidURIError
  abort "FATAL: UPSTREAM_URL '#{ENV['UPSTREAM_URL']}' is not a valid URI."
end

require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'webmock/rspec'
WebMock.allow_net_connect!
Rails.root.glob('spec/support/**/*.rb').sort_by(&:to_s).each { |f| require f }

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_model
    with.library :action_controller
  end
end

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
  config.include Requests::JsonHelpers, type: :request
end
