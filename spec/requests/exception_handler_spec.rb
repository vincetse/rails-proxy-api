require 'rails_helper'

RSpec.describe 'ExceptionHandler', type: :request do
  let(:todo_id) { '123' }
  let(:url) { "#{ENV['UPSTREAM_URL']}/todos/#{todo_id}.json" }

  describe 'ActiveResource Exception Mapping' do
    # Helper to check the response matches our ExceptionHandler logic
    def expect_error(status_code, expected_message, expected_http_status)
      WebMock.stub_request(:get, url).to_return(
        status: status_code,
        body: { error: "Remote Error" }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

      get "/todos/#{todo_id}"

      expect(response).to have_http_status(expected_http_status)
      expect(json['message']).to include(expected_message)
    end

    it 'handles 404 Not Found' do
      expect_error(404, "Not Found.", :not_found)
    end

    it 'handles 401 Unauthorized' do
      expect_error(401, "Unauthorized", :unauthorized)
    end

    it 'handles 403 Forbidden' do
      expect_error(403, "Forbidden", :forbidden)
    end

    it 'handles 422 Unprocessable Entity' do
      # Matches the "Validation failed" string from our controller logic
      expect_error(422, "Validation failed", :unprocessable_entity)
    end

    it 'handles 429 Too Many Requests' do
      expect_error(429, "Rate limit exceeded", :too_many_requests)
    end

    it 'handles 500 Internal Server Error' do
      # We mapped 5xx to 502 Bad Gateway
      expect_error(500, "Remote Server Error", :bad_gateway)
    end

    it 'handles connection timeouts' do
      WebMock.stub_request(:get, url).to_timeout

      get "/todos/#{todo_id}"

      expect(response).to have_http_status(:service_unavailable)
      expect(json['message']).to include("Network Error")
    end

    it 'handles connection refused' do
      # This triggers ActiveResource::ConnectionRefusedError
      WebMock.stub_request(:get, url).to_raise(Errno::ECONNREFUSED)

      get "/todos/#{todo_id}"

      expect(response).to have_http_status(:service_unavailable)
      expect(json['message']).to include("Network Error")
    end
  end
end
