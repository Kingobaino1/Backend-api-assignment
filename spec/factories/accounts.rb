FactoryBot.define do
  factory :account do
    username { Faker::Name.unique.name }
    password { Faker::Number.number(digits: 10) }
  end
end
