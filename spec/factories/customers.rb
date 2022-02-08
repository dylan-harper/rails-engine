FactoryBot.define do
  factory :customer do
    first_name { Faker::Lorem.characters(number: 3) }
    last_name { Faker::Lorem.characters(number: 5) }
  end
end
