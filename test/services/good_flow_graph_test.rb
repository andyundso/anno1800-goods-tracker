require "test_helper"

class GoodFlowGraphTest < ActiveSupport::TestCase
  test "should generate graph for one available good" do
    good = create(:available_good)

    graph = GoodFlowGraph.new(good).render

    assert_equal 1, graph.count
  end

  test "should generate graph for goods linked via input good" do
    output_good = create(:local_produced_good)
    input_good = create(:input_good, output_good: output_good)

    # lets take the short cut and generate the available goods
    UpdateAvailableGoodJob.perform_now(output_good.island_id, output_good.good_id)
    UpdateAvailableGoodJob.perform_now(output_good.island_id, input_good.input_good_id)

    available_input_good = AvailableGood.find_by!(
      good_id: input_good.input_good_id,
      island_id: output_good.island_id
    )

    graph = GoodFlowGraph.new(available_input_good).render

    # 2 nodes plus 1 edge
    assert_equal 3, graph.count
  end

  test "should generate graph for goods linked via output good" do
    output_good = create(:local_produced_good)
    input_good = create(:input_good, output_good: output_good)

    # lets take the short cut and generate the available goods
    UpdateAvailableGoodJob.perform_now(output_good.island_id, output_good.good_id)
    UpdateAvailableGoodJob.perform_now(output_good.island_id, input_good.input_good_id)

    available_output_good = AvailableGood.find_by!(
      good_id: output_good.good_id,
      island_id: output_good.island_id
    )

    graph = GoodFlowGraph.new(available_output_good).render

    # 2 nodes plus 1 edge
    assert_equal 3, graph.count
  end

  test "should generate graph for goods via export" do
    production_island = create(:island)
    target_island = create(:island, game: production_island.game)
    good = create(:local_produced_good, island: production_island)
    export = create(:export, local_produced_good: good, island: target_island)

    # lets take the short cut and generate the available goods
    UpdateAvailableGoodJob.perform_now(good.island_id, good.good_id)
    UpdateAvailableGoodJob.perform_now(export.island_id, good.good_id)

    available_output_good = AvailableGood.find_by!(
      good_id: good.good_id,
      island_id: good.island_id
    )

    graph = GoodFlowGraph.new(available_output_good).render

    # 2 nodes plus 1 edge
    assert_equal 3, graph.count
  end

  test "should generate graph for goods via import" do
    production_island = create(:island)
    target_island = create(:island, game: production_island.game)
    good = create(:local_produced_good, island: production_island)
    export = create(:export, local_produced_good: good, island: target_island)

    # lets take the short cut and generate the available goods
    UpdateAvailableGoodJob.perform_now(good.island_id, good.good_id)
    UpdateAvailableGoodJob.perform_now(export.island_id, good.good_id)

    available_output_good = AvailableGood.find_by!(
      good_id: good.good_id,
      island_id: export.island_id
    )

    graph = GoodFlowGraph.new(available_output_good).render

    # 2 nodes plus 1 edge
    assert_equal 3, graph.count
  end
end
