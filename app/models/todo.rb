class Todo < ActiveResource::Base
  # upstream
  self.site = ENV["UPSTREAM"]

  # model association
  has_many :items

  # validations
  validates_presence_of :title, :created_by
end
