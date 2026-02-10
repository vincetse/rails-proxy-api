class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update, :destroy]

  # GET /todos
  def index
    @todos = Todo.all
    json_response(@todos)
  end

  # POST /todos
  def create
    @todo = Todo.new(todo_params)
    if @todo.save
      json_response(@todo, :created)
    else
      # This returns the errors from the remote API
      json_response(@todo.errors, :unprocessable_entity)
    end
  rescue ActiveResource::ResourceInvalid => e
    # This catches the 422 error from the API specifically
    render json: { message: e.message }, status: :unprocessable_entity
  end

  # GET /todos/:id
  def show
    json_response(@todo)
  end

  # PUT /todos/:id
  def update
    @todo = Todo.find(params[:id])
    if @todo.update_attributes(todo_params)
      head :no_content
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /todos/:id
  def destroy
    @todo.destroy
    head :no_content
  end

  private

  def todo_params
    # whitelist params
    params.permit(:title, :created_by)
  end

  def set_todo
    @todo = Todo.find(params[:id])
  end
end
