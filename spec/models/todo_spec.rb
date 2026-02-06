require 'rails_helper'

RSpec.describe Todo, type: :model do
  let(:base_url) { Todo.site.to_s.chomp('/') }

  describe "fetching todos" do
    it "requests the correct upstream path" do
      stub_request(:get, "#{base_url}/todos/1.json")
        .to_return(status: 200, body: { id: 1, title: "Refactor code" }.to_json)

      todo = Todo.find(1)
      expect(todo.title).to eq("Refactor code")
    end
  end

  describe "associations" do
    it "correctly handles has_many items" do
      # ActiveResource expects nested resources at /todos/1/items.json
      stub_request(:get, "#{base_url}/todos/1.json")
        .to_return(status: 200, body: { id: 1, title: "Parent" }.to_json)

      stub_request(:get, "#{base_url}/todos/1/items.json")
        .to_return(status: 200, body: [{ id: 99, name: "Sub-task" }].to_json)

      todo = Todo.find(1)
      expect(todo.items.first.name).to eq("Sub-task")
    end
  end
end
