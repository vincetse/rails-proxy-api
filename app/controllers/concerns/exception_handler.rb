module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    # --- 1. Top Level / Generic Errors ---
    # Catches 5xx errors
    rescue_from ActiveResource::ServerError do |e|
      render json: { message: "Remote Server Error: #{e.message}" }, status: :bad_gateway
    end

    # Catches Connection/Network issues
    rescue_from ActiveResource::ConnectionError,
                ActiveResource::TimeoutError,
                ActiveResource::SSLError,
                ActiveResource::ConnectionRefusedError do |e|
      render json: { message: "Network Error: #{e.message}" }, status: :service_unavailable
    end

    # --- 2. Broad Client Errors (4xx) ---
    # This acts as a default for any 4xx not specified below
    rescue_from ActiveResource::ClientError do |e|
      render json: { message: "Client Error: #{e.message}" }, status: :unprocessable_entity
    end

    # --- 3. Specific Client Errors (Checked FIRST because they are at the BOTTOM) ---
    rescue_from ActiveResource::UnauthorizedAccess do |e|
      render json: { message: "Unauthorized: #{e.message}" }, status: :unauthorized
    end

    rescue_from ActiveResource::ForbiddenAccess do |e|
      render json: { message: "Forbidden: #{e.message}" }, status: :forbidden
    end

    rescue_from ActiveResource::ResourceConflict do |e|
      render json: { message: "Conflict/Validation Failed: #{e.message}" }, status: :unprocessable_entity
    end

    rescue_from ActiveResource::TooManyRequests do |e|
      render json: { message: "Rate limit exceeded. Try again later." }, status: :too_many_requests
    end

    rescue_from ActiveResource::ResourceNotFound do |e|
      render json: { message: "Not Found." }, status: :not_found
    end

    rescue_from ActiveResource::MissingPrefixParam do |e|
      render json: { message: "Developer Error: Nested resource ID missing." }, status: :internal_server_error
    end
  end
end
