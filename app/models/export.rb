class Export < ApplicationRecord
  belongs_to :local_produced_good
  has_one :good, through: :local_produced_good

  belongs_to :island

  validates :quantity, presence: true
end
