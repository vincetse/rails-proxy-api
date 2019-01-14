class Item < ActiveResource::Base
  # upstream
  self.site = "https://vt-todos-api.herokuapp.com/todos/:todo_id"

  # model association
  belongs_to :todo

  # validation
  validates_presence_of :name
end
