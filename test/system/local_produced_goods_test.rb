require "application_system_test_case"

class LocalProducedGoodsTest < ApplicationSystemTestCase
  test "user wants to add a local produced good - failure" do
    island = create(:island)

    visit game_path(island.game)

    within "##{dom_id(island)}" do
      find(".ri-add-line").click
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
      find(".ri-add-line").click
    end

    select good.name_de, from: "local_produced_good_good_id"
    fill_in "Production", with: 5.0
    fill_in "Consumption", with: 2.0

    assert_changes "LocalProducedGood.count", 1 do
      click_on "Speichern"

      assert_text "#{good.name_de} auf #{island.name} wurde erfasst."
    end
  end
end
