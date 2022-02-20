class GoodFlowGraph
  include Rails.application.routes.url_helpers

  def initialize(available_good)
    @available_good = available_good
    @output = []
  end

  def render
    examine_next_node(available_good)
    output
  end

  private

  def add_node(available_good)
    output << {
      consumption: available_good.consumption,
      good_name: available_good.good.name,
      # href: island_produced_good_path(produced_good.island, produced_good),
      id: available_good.id,
      island: available_good.island.name,
      image: rails_blob_path(available_good.good.icon, only_path: true),
      sparse: available_good.sparse,
      production: available_good.production,
      type: "node"
    }
  end

  def add_edge(to, from)
    output << {
      from: from.id,
      to: to.id,
      # label: quantity,
      type: "edge"
    }
  end

  def examine_next_node(available_good, link = nil, flip_edge = false)
    # avoid endless loops by returning early if we already saw something
    return if output.any? { |h| h[:id] == available_good.id }

    add_node(available_good)

    if link.present?
      add_edge(available_good, link) unless flip_edge
      add_edge(link, available_good) if flip_edge
    end

    # depending on the value set on the good, we can draw different links
    # for local consumption or production, we don't need to further draw links
    if available_good.export > 0.0
      find_export_islands(available_good)
    end

    if available_good.local_usage > 0.0
      # something is using this good as an input
      find_output_goods(available_good)
    end

    if available_good.import > 0.0
      find_import_goods(available_good)
    end

    if available_good.consumption > 0.0 || available_good.production > 0.0
      # check if we have input goods for the "implicit" produced good
      find_input_goods(available_good)
    end
  end

  def find_export_islands(available_good)
    island_ids = Export
      .joins(:local_produced_good)
      .where(local_produced_goods: {island_id: available_good.island_id, good_id: available_good.good_id})
      .pluck(:island_id)

    AvailableGood.where(
      good_id: available_good.good_id,
      island_id: island_ids
    ).each { |ag| examine_next_node(ag, available_good) }
  end

  def find_input_goods(available_good)
    LocalProducedGood.find_by(
      island_id: available_good.island_id,
      good_id: available_good.good_id
    )&.input_goods&.each do |input_good|
      ag = AvailableGood.find_by(
        good_id: input_good.input_good_id,
        island_id: available_good.island_id
      )

      examine_next_node(ag, available_good, true)
    end
  end

  def find_import_goods(available_good)
    island_ids = LocalProducedGood
      .joins(:exports)
      .where(local_produced_goods: {good_id: available_good.good_id})
      .where(exports: {island_id: available_good.island_id})
      .pluck(:island_id)

    AvailableGood.where(
      good_id: available_good.good_id,
      island_id: island_ids
    ).each { |ag| examine_next_node(ag, available_good, true) }
  end

  def find_output_goods(available_good)
    good_ids = LocalProducedGood
      .joins(:input_goods)
      .where(local_produced_goods: {island_id: available_good.island_id})
      .where(input_goods: {input_good_id: available_good.good_id})
      .pluck(:good_id)

    AvailableGood.where(
      good_id: good_ids,
      island_id: available_good.island_id
    ).each { |ag| examine_next_node(ag, available_good) }
  end

  attr_accessor :available_good, :output
end
