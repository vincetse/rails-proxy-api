FactoryBot.define do
  factory :item do
    name { Faker::Movies::StarWars.character }
    done { false }

    # We use a transient attribute to hold the todo object/id
    transient do
      todo { nil }
    end

    # Before saving, inject the ID into ActiveResource's prefix_options
    after(:build) do |item, evaluator|
      if evaluator.todo
        item.prefix_options[:todo_id] = evaluator.todo.id
      elsif item.respond_to?(:todo_id) && item.todo_id
        # Fallback if you passed todo_id: X directly
        item.prefix_options[:todo_id] = item.todo_id
      end
    end
  end
end
