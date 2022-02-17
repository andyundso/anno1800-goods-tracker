class Region < ApplicationRecord
  extend Mobility
  translates :name, type: :string

  has_many :islands, dependent: :destroy

  has_one_attached :icon
end
