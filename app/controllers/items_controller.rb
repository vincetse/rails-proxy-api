class ItemsController < ApplicationController
  before_action :set_todo
  before_action :set_todo_item, only: [:show, :update, :destroy]

  # GET /todos/:todo_id/items
  def index
    json_response(@todo.items)
  end

  # GET /todos/:todo_id/items/:id
  def show
    json_response(@item)
  end

  # POST /todos/:todo_id/items
  def create
    @item = Item.new(item_params)
    @item.prefix_options[:todo_id] = @todo.id

    if @item.save
      # Return the item so the test can easily grab ['id']
      json_response(@item, :created)
    else
      json_response(@item.errors, :unprocessable_entity)
    end
  end

  # PUT /todos/:todo_id/items/:id
  def update
    @item = Item.find(params[:id], params: { todo_id: params[:todo_id] })
    @item.prefix_options[:todo_id] = params[:todo_id]
    @item.attributes = item_params
    @item.id = params[:id]
    if @item.save
      head :no_content
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  rescue ActiveResource::ResourceNotFound
    render json: { message: "Couldn't find Item" }, status: :not_found
  end

  # DELETE /todos/:todo_id/items/:id
  def destroy
    @item.destroy
    head :no_content
  end

  private

  def item_params
    params.permit(:name, :done)
  end

  def set_todo
    @todo = Todo.find(params[:todo_id])
  rescue ActiveResource::ResourceNotFound
    render json: { message: "Not Found." }, status: :not_found
  end

  def set_todo_item
    # This builds the URL: /todos/:todo_id/items/:id.json
    @item = Item.find(params[:id], params: { todo_id: params[:todo_id] })
  rescue ActiveResource::ResourceNotFound
    render json: { message: "Couldn't find Item" }, status: :not_found
  end
end
