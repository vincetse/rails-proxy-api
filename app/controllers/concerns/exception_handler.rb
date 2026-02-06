module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    # 1. Handle "Not Found" errors
    # ActiveResource raises ActiveResource::ResourceNotFound (404)
    rescue_from ActiveResource::ResourceNotFound do |e|
      render json: { message: e.message }, status: :not_found
    end

    # 2. Handle "Invalid Record" errors
    # ActiveResource raises ActiveResource::ResourceInvalid (422)
    rescue_from ActiveResource::ResourceInvalid do |e|
      render json: { message: e.message }, status: :unprocessable_entity
    end

    # 3. Handle Connection Errors (Optional but recommended)
    rescue_from ActiveResource::ConnectionError, Errno::ECONNREFUSED do |e|
      render json: { message: "Upstream API is unavailable" }, status: :service_unavailable
    end
  end
end
