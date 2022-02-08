FactoryBot.define do
  factory :merchant do
    name { Faker::Lorem.characters(number: 5) }
  end
end
