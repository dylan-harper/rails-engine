FactoryBot.define do
  factory :item do
    name { Faker::Lorem.characters(number: 5) }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    unit_price { Faker::Number.decimal(l_digits: 2) }
    merchant_id { Faker::Number.number(digits: 1) }
  end
end
