FactoryBot.define do
  factory :input_good do
    association :input_good, factory: :good
    association :output_good, factory: :local_produced_good
  end
end
