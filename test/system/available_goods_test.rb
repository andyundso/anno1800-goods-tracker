require "application_system_test_case"

class AvailableGoodsTest < ApplicationSystemTestCase
  test "should show graph" do
    good = create(:available_good)

    visit game_path(good.island.game_id)

    find(".h-16").click

    within "#modal-body" do
      assert_selector "svg"
    end
  end

  test "can navigate with icons from the graph" do
    production_island = create(:island)
    target_island = create(:island, game: production_island.game)
    good = create(:local_produced_good, island: production_island)
    export = create(:export, local_produced_good: good, island: target_island)

    # lets take the short cut and generate the available goods
    UpdateAvailableGoodJob.perform_now(good.island_id, good.good_id)
    UpdateAvailableGoodJob.perform_now(export.island_id, good.good_id)

    visit game_path(target_island.game)

    export_available_good = AvailableGood.find_by!(
      island_id: good.island_id,
      good_id: good.good_id
    )

    import_available_good = AvailableGood.find_by!(
      island_id: export.island_id,
      good_id: good.good_id
    )

    within "##{dom_id(export_available_good)}" do
      find(".h-16").click
    end

    assert_text "#{export_available_good.good.name} auf #{export_available_good.island.name}"
    find("tspan", text: import_available_good.island.name).click
    assert_text "#{import_available_good.good.name} auf #{import_available_good.island.name}"
  end
end
