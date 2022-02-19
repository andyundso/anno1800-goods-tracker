FactoryBot.define do
  factory :good do
    name_de { Faker::Food.ingredient }
    name_en { Faker::Food.ingredient }

    after(:build) do |good|
      good.icon.attach(
        io: File.open(Rails.root.join("test/files/icon.png")),
        filename: "icon.png",
        content_type: "image/png"
      )
    end
  end
end
