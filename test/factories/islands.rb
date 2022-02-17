FactoryBot.define do
  factory :island do
    game
    name { Faker::Ancient.hero }
    region
  end
end
