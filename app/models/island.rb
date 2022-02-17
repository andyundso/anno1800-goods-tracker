class Island < ApplicationRecord
  belongs_to :game
  belongs_to :region

  validates :name, presence: true

  after_create_commit { broadcast_append_later_to(game) }
  after_update_commit { broadcast_replace_later_to(game) }
  after_destroy_commit { broadcast_remove_to(game) }
end
