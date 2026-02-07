require 'active_resource'

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    # 1. Handle 404 specifically (Since 'ResourceNotFound' exists in your list)
    rescue_from ActiveResource::ResourceNotFound do |e|
      render json: { message: e.message }, status: :not_found
    end

    # 2. Handle 409 specifically (Since 'ResourceConflict' exists in your list)
    rescue_from ActiveResource::ResourceConflict do |e|
      render json: { message: e.message }, status: :conflict
    end

    # 3. Handle everything else (including 422) via ClientError
    rescue_from ActiveResource::ClientError do |e|
      if e.response.code.to_i == 422
        render json: { message: e.message }, status: :unprocessable_entity
      else
        render json: { message: "Upstream error: #{e.message}" }, status: e.response.code.to_i
      end
    end

    # 4. Handle 5xx errors
    rescue_from ActiveResource::ServerError do |e|
      render json: { message: "Upstream server is currently unavailable" }, status: :service_unavailable
    end
  end
end
