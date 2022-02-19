FactoryBot.define do
  factory :export do
    island
    local_produced_good
    quantity { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  end
end
