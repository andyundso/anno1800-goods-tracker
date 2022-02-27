require "application_system_test_case"

class LocalProducedGoodsTest < ApplicationSystemTestCase
  test "user wants to add a local produced good - failure" do
    island = create(:island)

    visit game_path(island.game)

    within "##{dom_id(island)}" do
      find(".add-island").click
    end

    assert_no_changes "LocalProducedGood.count" do
      click_on "Speichern"

      assert_text "Good muss ausgefüllt werden"
    end
  end

  test "user wants to add a local produced good - success" do
    island = create(:island)
    good = create(:good)

    visit game_path(island.game)

    within "##{dom_id(island)}" do
      find(".add-island").click
    end

    select good.name_de, from: "local_produced_good_good_id"
    fill_in "Production", with: 5.0
    fill_in "Consumption", with: 2.0

    assert_changes "LocalProducedGood.count", 1 do
      click_on "Speichern"
      assert_text "#{good.name_de} auf #{island.name} wurde erfasst."
    end

    # Ensure the available good gets produced
    within "#available_goods_#{island.id}" do
      assert_selector "turbo-frame", count: 1
    end
  end

  test "user wants to add a local good with an input good" do
    island = create(:island)
    input_good = create(:good)
    output_good = create(:good)

    visit game_path(island.game)

    within "##{dom_id(island)}" do
      find(".add-island").click
    end

    select output_good.name_de, from: "local_produced_good_good_id"

    click_on "Eingabeware hinzufügen"
    within ".nested-fields" do
      fill_in_tom_select_field(".ts-wrapper", input_good.name_de)
    end

    fill_in "Production", with: 5.0
    fill_in "Consumption", with: 2.0

    assert_difference -> { LocalProducedGood.count } => 1, -> { AvailableGood.count } => 2 do
      click_on "Speichern"
      assert_text "#{output_good.name_de} auf #{island.name} wurde erfasst."
    end

    # Ensure the available good gets produced
    within "#available_goods_#{island.id}" do
      assert_selector "turbo-frame", count: 2
    end
  end

  test "user wants to add a local good with an export island" do
    production_island = create(:island)
    target_island = create(:island, game: production_island.game)
    good = create(:good)

    visit game_path(production_island.game)

    within "##{dom_id(production_island)}" do
      find(".add-island").click
    end

    select good.name_de, from: "local_produced_good_good_id"

    click_on "Export hinzufügen"
    fill_in "Quantity", with: 5.0
    within ".nested-fields" do
      fill_in_tom_select_field(".ts-wrapper", target_island.name)
    end

    fill_in "Production", with: 5.0

    assert_difference -> { LocalProducedGood.count } => 1, -> { AvailableGood.count } => 2, -> { Export.count } => 1 do
      click_on "Speichern"
      assert_text "#{good.name_de} auf #{production_island.name} wurde erfasst."
    end

    # Ensure the available good gets produced
    within "#available_goods_#{production_island.id}" do
      assert_selector "turbo-frame", count: 1
    end

    within "#available_goods_#{target_island.id}" do
      assert_selector "turbo-frame", count: 1
    end
  end

  test "user wants to edit local produced good - success" do
    local_produced_good = create(:local_produced_good)
    available_good = AvailableGood.find_by(
      good_id: local_produced_good.good_id,
      island_id: local_produced_good.island_id
    )

    visit game_path(local_produced_good.game)

    find("##{dom_id(available_good)} img").click
    assert_text "#{available_good.good.name} auf #{available_good.island.name}"

    click_on "Ändern"

    fill_in "Production", with: 15.0

    assert_changes "local_produced_good.reload.production", to: 15.0 do
      click_on "Speichern"
      assert_text "#{local_produced_good.good.name} auf #{local_produced_good.island.name} wurde aktualisiert."
    end
  end

  test "user wants to delete local produced good" do
    local_produced_good = create(:local_produced_good)
    available_good = AvailableGood.find_by(
      good_id: local_produced_good.good_id,
      island_id: local_produced_good.island_id
    )

    visit game_path(local_produced_good.game)

    find("##{dom_id(available_good)} img").click
    assert_text "#{available_good.good.name} auf #{available_good.island.name}"

    assert_difference "LocalProducedGood.count", -1 do
      click_on "Löschen"
      assert_text "Ware wurde gelöscht."
    end
  end
end
