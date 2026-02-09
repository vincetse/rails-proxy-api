class RemoteResource < ActiveResource::Base
  self.site = Rails.application.config_for(:settings).upstream_url
end
