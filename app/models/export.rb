class Export < ApplicationRecord
  belongs_to :local_produced_good
  has_one :good, through: :local_produced_good

  belongs_to :island

  validates :quantity, presence: true

  after_create_commit { update_available_goods }
  after_update_commit { update_available_goods }
  after_destroy_commit { update_available_goods }

  private

  def update_available_goods
    # target island, production island is covered by local produced good
    UpdateAvailableGoodJob.perform_later(island_id, local_produced_good.good_id)
  end
end
