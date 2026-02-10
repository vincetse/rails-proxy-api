require 'rails_helper'

RSpec.describe 'Items API', type: :request do

  let(:created_todo_ids) { [] }
  let(:todo_attributes) { { title: 'Master Ruby', created_by: '1' } }
  let(:item_attributes) { { name: 'Learn ActiveResource' } }

  # We use a before(:all) or a memoized helper to ensure the remote
  # resource is created via the actual API before we test GET/PUT
  let!(:todo_id) do
    post '/todos', params: todo_attributes
    JSON.parse(response.body)['id']
  end

  let!(:item_id) do
    #created_todo_ids << todo_id
    post "/todos/#{todo_id}/items", params: item_attributes
    # Your POST /items returns the TODO object, so we find the item ID
    # OR if your API returns the item, grab it directly:
    JSON.parse(response.body)['id']
  end

  # Test suite for GET /todos/:todo_id/items
  describe 'GET /todos/:todo_id/items' do
    before { get "/todos/#{todo_id}/items" }

    context 'when todo exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all todo items' do
        expect(json.size).to eq(1)
      end
    end

    context 'when todo does not exist' do
      let(:todo_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Not Found./)
      end
    end
  end

  # Test suite for GET /todos/:todo_id/items/:item_id
  describe 'GET /todos/:todo_id/items/:item_id' do
    before { get "/todos/#{todo_id}/items/#{item_id}" }

    context 'when todo item exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the item' do
        expect(json['id']).to eq(item_id)
      end
    end

    context 'when todo item does not exist' do
      let(:item_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  # Test suite for PUT /todos/:todo_id/items
  describe 'POST /todos/:todo_id/items' do
    let(:valid_attributes) { { name: 'Visit Narnia', done: false } }

    context 'when request attributes are valid' do
      before { post "/todos/#{todo_id}/items", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/todos/#{todo_id}/items", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/can't be blank/)
      end
    end
  end

  describe 'PUT /todos/:item_id' do
    let(:valid_attributes) { { title: 'Shopping' } }

    context 'when the record exists' do
      before { put "/todos/#{todo_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for PUT /todos/:todo_id/items/:item_id
  describe 'PUT /todos/:todo_id/items/:item_id' do
    let(:valid_attributes) { { name: 'Mozart' } }
    before { put "/todos/#{todo_id}/items/#{item_id}", params: valid_attributes }

    context 'when item exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the item' do
        updated_item = Item.find(item_id, params: { todo_id: todo_id })
        expect(updated_item.name).to match(/Mozart/)
      end
    end

    context 'when the item does not exist' do
      let(:item_id) { '00000000-0000-0000-0000-000000000000' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  # Test suite for DELETE /todos/:item_id
  describe 'DELETE /todos/:item_id' do
    before { delete "/todos/#{todo_id}/items/#{item_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
