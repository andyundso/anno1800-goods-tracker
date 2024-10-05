FactoryBot.define do
  factory :trade do
    association :input_good, factory: :good
    input_good_quantity { Faker::Number.decimal(l_digits: 2, r_digits: 2) }

    association :output_good, factory: :good
    output_good_quantity { Faker::Number.decimal(l_digits: 2, r_digits: 2) }

    island
  end
end
