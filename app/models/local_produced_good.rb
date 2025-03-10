class LocalProducedGood < ApplicationRecord
  belongs_to :island
  has_one :game, through: :island

  belongs_to :good

  has_many :input_goods, class_name: "InputGood", inverse_of: :output_good, foreign_key: :output_good_id,
    dependent: :destroy
  accepts_nested_attributes_for :input_goods, reject_if: :all_blank, allow_destroy: true

  has_many :exports, class_name: "Export", inverse_of: :local_produced_good, dependent: :destroy
  accepts_nested_attributes_for :exports, reject_if: :all_blank, allow_destroy: true

  after_create_commit { update_available_goods }
  after_update_commit { update_available_goods }
  after_destroy_commit { update_available_goods }

  private

  def update_available_goods
    UpdateAvailableGoodJob.perform_later(island_id, good_id)
    ActiveJob.perform_all_later(exports.map { |e| UpdateAvailableGoodJob.perform_later(e.island_id, good_id) })

    if good_id_before_last_save.present? && good_id != good_id_before_last_save
      UpdateAvailableGoodJob.perform_later(island_id, good_id_before_last_save)
      ActiveJob.perform_all_later(exports.map { |e| UpdateAvailableGoodJob.perform_later(e.island_id, good_id_before_last_save) })
    end
  end
end
