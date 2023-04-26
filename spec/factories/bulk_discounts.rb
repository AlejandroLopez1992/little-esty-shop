FactoryBot.define do
  factory :bulk_discount do
    name { Faker::Ancient.god }
    percentage_discount { rand(1..99)}
    quantity_threshold {rand(5..50)}
  end
end