require "test_helper"

class GoodFlowGraphTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "should generate graph for one available good" do
    good = create(:available_good)

    graph = GoodFlowGraph.new(good).render

    assert_equal 1, graph.count
  end

  test "should generate graph for goods linked via input good" do
    output_good = create(:local_produced_good)
    input_good = create(:input_good, output_good: output_good)

    perform_enqueued_jobs

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
    create(:input_good, output_good: output_good)

    perform_enqueued_jobs

    available_output_good = AvailableGood.find_by!(
      good_id: output_good.good_id,
      island_id: output_good.island_id
    )

    graph = GoodFlowGraph.new(available_output_good).render

    # 2 nodes plus 1 edge
    assert_equal 3, graph.count
  end

  test "should generate graph for goods via export" do
    export = build(:export)
    perform_enqueued_jobs do
      export.save!
    end

    available_output_good = AvailableGood.find_by!(
      good_id: export.local_produced_good.good_id,
      island: export.local_produced_good.island_id
    )

    graph = GoodFlowGraph.new(available_output_good).render

    # 2 nodes plus 1 edge
    assert_equal 3, graph.count
  end

  test "should generate graph for goods via import" do
    export = build(:export)
    perform_enqueued_jobs do
      export.save!
    end

    available_output_good = AvailableGood.find_by!(
      good_id: export.local_produced_good.good_id,
      island_id: export.island_id
    )

    graph = GoodFlowGraph.new(available_output_good).render

    # 2 nodes plus 1 edge
    assert_equal 3, graph.count
  end

  test "should generate graph for goods via Dockland trade" do
    trade = create(:trade)

    perform_enqueued_jobs

    available_good = AvailableGood.find_by!(
      good_id: trade.input_good_id,
      island_id: trade.island_id
    )

    graph = GoodFlowGraph.new(available_good).render

    assert_equal 3, graph.count
  end
end
