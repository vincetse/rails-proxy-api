FactoryBot.define do
  factory :item do
    name { Faker::Movies::StarWars.character }
    done { false }
    association :todo
  end
end
