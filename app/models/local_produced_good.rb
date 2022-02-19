class LocalProducedGood < ApplicationRecord
  belongs_to :island
  has_one :game, through: :island

  belongs_to :good

  after_create_commit { update_available_goods }
  after_update_commit { update_available_goods }
  after_destroy_commit { update_available_goods }

  private

  def update_available_goods
    UpdateAvailableGoodJob.perform_later(island_id, good_id)
  end
end
