class InputGood < ApplicationRecord
  belongs_to :input_good, class_name: "Good"
  belongs_to :output_good, class_name: "LocalProducedGood", inverse_of: :input_goods

  after_create_commit { update_available_goods }
  after_update_commit { update_available_goods }
  after_destroy_commit { update_available_goods }

  def update_available_goods
    UpdateAvailableGoodJob.perform_later(output_good.island_id, input_good_id)
  end
end
