require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:upstream) { ENV.fetch('UPSTREAM', 'http://localhost:3000').chomp('/') }
  let(:todo_id)  { 10 }
  let(:item_id)  { 5 }

  describe "fetching a nested item" do
    it "interpolates the todo_id into the URL" do
      # Notice the URL structure: /todos/10/items/5.json
      target_url = "#{upstream}/todos/#{todo_id}/items/#{item_id}.json"

      stub_request(:get, target_url)
        .to_return(status: 200, body: { id: item_id, name: "Buy Milk", todo_id: todo_id }.to_json)

      item = Item.find(item_id, params: { todo_id: todo_id })

      expect(item.name).to eq("Buy Milk")
      expect(WebMock).to have_requested(:get, target_url).once
    end
  end

  describe "validations" do
    it "is invalid without a name" do
      item = Item.new(name: nil)
      expect(item).not_to be_valid
      expect(item.errors[:name]).to include("can't be blank")
    end
  end
end
