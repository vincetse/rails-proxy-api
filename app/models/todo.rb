class Todo < RemoteResource
  self.primary_key = :id
  # model association
  has_many :items

  # validations
  validates_presence_of :title, :created_by

  schema do
    string :title
    string :created_by
  end
end
