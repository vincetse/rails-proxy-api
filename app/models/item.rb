class Item < RemoteResource
  self.primary_key = :id
  # We override the site to include the nesting pattern
  # Note: ActiveResource uses :todo_id as a placeholder
  self.site = "#{Item.site.to_s.chomp('/')}/todos/:todo_id"

  # model association
  belongs_to :todo

  # validation
  validates_presence_of :name

  schema do
    string :id
    string :name
  end
end
