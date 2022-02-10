FactoryBot.define do
  factory :invoice do
    customer_id { Faker::Number.number(digits: 1) }
    merchant_id { Faker::Number.number(digits: 1) }
    status { Faker::Lorem.characters(number: 5) }
  end
end
