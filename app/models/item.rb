class Item < RemoteResource
  # We override the site to include the nesting pattern
  # Note: ActiveResource uses :todo_id as a placeholder
  self.site = "#{ENV.fetch('UPSTREAM', 'http://localhost:3000')}/todos/:todo_id"

  # model association
  belongs_to :todo

  # validation
  validates_presence_of :name
end
