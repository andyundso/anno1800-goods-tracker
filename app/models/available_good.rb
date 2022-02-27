class AvailableGood < ApplicationRecord
  belongs_to :good

  belongs_to :island
  has_one :game, through: :island

  after_create_commit { broadcast_append_later_to(game, target: "available_goods_#{island_id}") }
  after_update_commit { broadcast_update_later_to(game, target: self) }
  after_destroy_commit { broadcast_remove_to(game, target: "available_goods_#{island_id}") }

  def no_values?
    consumption.zero? && production.zero? && local_usage.zero? && import.zero? && export.zero?
  end

  def sparse
    production.to_d + import.to_d - consumption.to_d - local_usage.to_d - export.to_d
  end

  def update_values
    self.production = calculate_production
    self.consumption = calculate_consumption
    self.local_usage = calculate_local_usage

    self.export = calculate_exports
    self.import = calculate_imports

    self
  end

  private

  def calculate_consumption
    LocalProducedGood.where(
      good_id: good_id,
      island_id: island_id
    ).sum(:consumption)
  end

  def calculate_exports
    Export
      .joins(:local_produced_good)
      .where(local_produced_goods: {good_id: good_id, island_id: island_id})
      .sum(:quantity)
  end

  def calculate_imports
    Export
      .joins(:local_produced_good)
      .where(exports: {island_id: island_id})
      .where(local_produced_goods: {good_id: good_id})
      .sum(:quantity)
  end

  def calculate_local_usage
    LocalProducedGood
      .joins(:input_goods)
      .where(local_produced_goods: {island_id: island_id})
      .where(input_goods: {input_good_id: good_id})
      .sum(:production)
  end

  def calculate_production
    LocalProducedGood.where(
      good_id: good_id,
      island_id: island_id
    ).sum(:production)
  end
end
