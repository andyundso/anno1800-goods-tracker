class Good < ApplicationRecord
  extend Mobility
  translates :name, type: :string

  has_one_attached :icon
end
