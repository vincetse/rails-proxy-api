require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  describe 'Check CORS headers' do
    headers = { 'HTTP_ORIGIN' => 'http://example.com' }
    before { get '/todos', :headers => headers }
    it 'returns CORS headers' do
      expect(response.headers['Access-Control-Allow-Origin']).to eq '*'
    end
  end
end
