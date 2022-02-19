class Island < ApplicationRecord
  belongs_to :game
  belongs_to :region

  has_many :available_goods, dependent: :destroy
  has_many :local_produced_goods, dependent: :destroy

  validates :name, presence: true

  after_create_commit { broadcast_append_later_to(game) }
  after_update_commit { broadcast_replace_later_to(game) }
  after_destroy_commit { broadcast_remove_to(game) }
end
