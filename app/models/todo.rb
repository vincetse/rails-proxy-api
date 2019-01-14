class Todo < ActiveResource::Base
  # upstream
  self.site = "https://vt-todos-api.herokuapp.com"

  # model association
  has_many :items

  # validations
  validates_presence_of :title, :created_by
end
