class Todo < RemoteResource
  # model association
  has_many :items

  # validations
  validates_presence_of :title, :created_by
end
