class AvailableGood < ApplicationRecord
  belongs_to :good

  belongs_to :island
  has_one :game, through: :island

  after_create_commit { broadcast_append_later_to(game, target: "available_goods_#{island_id}") }
  after_update_commit { broadcast_update_later_to(game) }
  after_destroy_commit { broadcast_remove_to(game) }

  def no_values?
    consumption.zero? && production.zero? && local_usage.zero? && island_import.zero? && island_export.zero? && dockland_import.zero? && dockland_export.zero?
  end

  def sparse
    making = production.to_d + island_import.to_d + dockland_import.to_d
    using = consumption.to_d + local_usage.to_d + island_export.to_d + dockland_export.to_d

    making - using
  end

  def update_values
    self.production = calculate_production
    self.consumption = calculate_consumption
    self.local_usage = calculate_local_usage

    self.island_export = calculate_island_exports
    self.island_import = calculate_island_imports

    self.dockland_export = calculate_dockland_exports
    self.dockland_import = calculate_dockland_imports

    self
  end

  private

  def calculate_consumption
    LocalProducedGood.where(
      good_id: good_id,
      island_id: island_id
    ).sum(:consumption)
  end

  def calculate_island_exports
    Export
      .joins(:local_produced_good)
      .where(local_produced_goods: {good_id: good_id, island_id: island_id})
      .sum(:quantity)
  end

  def calculate_island_imports
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

  def calculate_dockland_exports
    Trade.where(
      input_good_id: good_id,
      island_id:
    ).sum(:input_good_quantity).to_d / 20
  end

  def calculate_dockland_imports
    Trade.where(
      output_good_id: good_id,
      island_id:
    ).sum(:output_good_quantity).to_d / 20
  end
end
