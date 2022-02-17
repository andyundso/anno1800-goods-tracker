class Game < ApplicationRecord
  has_many :islands, dependent: :destroy
end
