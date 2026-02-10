require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  # Use a helper to track created todos for cleanup
  let(:created_todo_ids) { [] }

  # Automatically delete every todo created during a test
  after(:each) do
    created_todo_ids.each do |id|
      delete "/todos/#{id}"
    rescue StandardError => e
      puts "Cleanup failed for ID #{id}: #{e.message}"
    end
  end

  # Test suite for GET /todos/:id
  describe 'GET /todos/:id' do
    # 'let!' triggers creation immediately; we save the ID for cleanup
    let!(:todo) do
      create(:todo).tap { |t| created_todo_ids << t.id }
    end
    let(:todo_id) { todo.id }

    # This is the Todo just created
    context 'when the record exists' do
      before { get "/todos/#{todo_id}" }
      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:todo_id) { 100 }
      before { get "/todos/#{todo_id}" }

      pending "This test may fail if the upstream already contains data" \
              "created outside of this test."
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Not Found./)
      end
    end
  end

  # Try to create a record
  describe 'POST /todos' do
    # valid payload
    let(:valid_attributes) { { title: 'Learn Elm', created_by: '1' } }

    context 'when the request is valid' do
      before { post '/todos', params: valid_attributes }
      after { delete "/todos/#{json['id']}" }

      it 'creates a todo' do
        expect(json['title']).to eq('Learn Elm')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/todos', params: { title: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/can't be blank/)
      end
    end
  end

  # Edit a Todo
  describe 'PUT /todos/:id' do
    let!(:todo) do
      create(:todo).tap { |t| created_todo_ids << t.id }
    end
    let(:todo_id) { todo.id }
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


  # Test suite for DELETE /todos/:id
  describe 'DELETE /todos/:id' do
    # 'let!' triggers creation immediately; we save the ID for cleanup
    let!(:todo) { create(:todo) }
    let(:todo_id) { todo.id }
    before { delete "/todos/#{todo_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
