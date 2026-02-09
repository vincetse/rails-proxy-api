require 'rails_helper'

RSpec.describe "Roots", type: :request do
  describe "GET /" do
    before { get '/' }

    it 'returns root' do
      expect(json).to be_empty
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
