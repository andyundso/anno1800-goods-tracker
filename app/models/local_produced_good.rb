class LocalProducedGood < ApplicationRecord
  belongs_to :island
  has_one :game, through: :island

  belongs_to :good
end
