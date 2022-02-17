class Region < ApplicationRecord
  extend Mobility
  translates :name, type: :string

  has_one_attached :avatar
end
