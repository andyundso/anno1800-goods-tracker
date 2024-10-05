class Trade < ApplicationRecord
  belongs_to :input_good, class_name: "Good"
  belongs_to :output_good, class_name: "Good"

  belongs_to :island
  has_one :game, through: :island

  validates :input_good_quantity, :output_good_quantity, presence: true

  after_create_commit { update_available_goods }
  after_update_commit { update_available_goods }
  after_destroy_commit { update_available_goods }

  private

  def update_available_goods
    UpdateAvailableGoodJob.perform_later(island_id, input_good_id)
    UpdateAvailableGoodJob.perform_later(island_id, output_good_id)

    UpdateAvailableGoodJob.perform_later(island_id, input_good_id_before_last_save) if input_good_id != input_good_id_before_last_save
    UpdateAvailableGoodJob.perform_later(island_id, output_good_id_before_last_save) if output_good_id != output_good_id_before_last_save
  end
end
