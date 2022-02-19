class UpdateAvailableGoodJob < ApplicationJob
  queue_as :default

  def perform(island_id, good_id)
    available_good = AvailableGood.find_or_initialize_by(
      good_id: good_id,
      island_id: island_id
    )

    available_good.update_values

    if available_good.no_values?
      available_good.destroy!
    else
      available_good.save!
    end
  end
end
