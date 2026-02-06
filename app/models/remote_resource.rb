class RemoteResource < ActiveResource::Base
  # Fallback to a default if UPSTREAM is missing
  self.site = ENV.fetch('UPSTREAM', 'http://localhost:3000')
end
