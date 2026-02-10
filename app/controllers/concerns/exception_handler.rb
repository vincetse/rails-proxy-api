module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    # This catches ConnectionRefused, Timeout, and SSLErrors
    rescue_from ActiveResource::ConnectionError,
                ActiveResource::ConnectionRefusedError,
                ActiveResource::TimeoutError do |e|
      render json: { message: "Network Error: #{e.message}" }, status: :service_unavailable
    end

    # 2. 5xx Server Errors
    rescue_from ActiveResource::ServerError do |e|
      render json: { message: "Remote Server Error: #{e.message}" }, status: :bad_gateway
    end

    # 3. 4xx Client Errors (Logic for 422 vs others)
    rescue_from ActiveResource::ClientError do |e|
      if e.response.code == '422'
        render json: { message: "Validation failed: #{e.message}" }, status: :unprocessable_entity
      else
        render json: { message: "Client Error: #{e.message}" }, status: :unprocessable_entity
      end
    end

    # 4. Most Specific Errors (Bottom of file = First checked)
    rescue_from ActiveResource::UnauthorizedAccess do |e|
      render json: { message: "Unauthorized: #{e.message}" }, status: :unauthorized
    end

    rescue_from ActiveResource::ForbiddenAccess do |e|
      render json: { message: "Forbidden: #{e.message}" }, status: :forbidden
    end

    rescue_from ActiveResource::TooManyRequests do |e|
      render json: { message: "Rate limit exceeded. Try again later." }, status: :too_many_requests
    end

    rescue_from ActiveResource::ResourceNotFound do |e|
      render json: { message: "Not Found." }, status: :not_found
    end
  end
end
