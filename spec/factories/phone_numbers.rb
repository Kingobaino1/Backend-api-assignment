FactoryBot.define do
  factory :phone_number do
    number { Faker::PhoneNumber.cell_phone }
  end
end
