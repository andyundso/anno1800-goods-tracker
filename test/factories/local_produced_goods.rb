FactoryBot.define do
  factory :local_produced_good do
    consumption { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    good
    island
    production { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  end
end
