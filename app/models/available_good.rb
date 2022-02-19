class AvailableGood < ApplicationRecord
  belongs_to :good

  belongs_to :island
  has_one :game, through: :island

  after_create_commit { broadcast_append_later_to(game, target: "available_goods_#{island_id}") }
  after_update_commit { broadcast_update_later_to(game, target: self) }
  after_destroy_commit { broadcast_remove_to(game, target: "available_goods_#{island_id}") }

  def no_values?
    consumption.zero? && production.zero?
  end

  def sparse
    production.to_d - consumption.to_d
  end

  def update_values
    self.production = calculate_production
    self.consumption = calculate_consumption

    self
  end

  private

  def calculate_consumption
    LocalProducedGood.where(
      good_id: good_id,
      island_id: island_id
    ).sum(:consumption)
  end

  def calculate_production
    LocalProducedGood.where(
      good_id: good_id,
      island_id: island_id
    ).sum(:production)
  end
end
