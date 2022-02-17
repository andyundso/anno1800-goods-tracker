require "application_system_test_case"

class IslandsTest < ApplicationSystemTestCase
  test "user wants to add a new island - failure" do
    game = create(:game)

    visit game_path(game)

    click_on "Neue Insel erfassen"

    assert_no_difference "Island.count" do
      click_on "Speichern"

      assert_text "Region muss ausgefüllt werden"
      assert_text "Name muss ausgefüllt werden"
    end
  end

  test "user wants to add a new island - success" do
    game = create(:game)
    region = create(:region)

    visit game_path(game)

    click_on "Neue Insel erfassen"

    fill_in "Name", with: "Good island"
    select region.name_de, from: "island_region_id"

    assert_difference "Island.count", 1 do
      click_on "Speichern"

      assert_text "Good island wurde angelegt."
    end
  end

  test "user wants to edit an island - failure" do
    island = create(:island)

    visit game_path(island.game)

    within "##{dom_id(island)}" do
      find(".ri-edit-line").click
    end

    fill_in "Name", with: ""

    assert_no_changes "island.reload.name" do
      click_on "Speichern"

      assert_text "Name muss ausgefüllt werden"
    end
  end

  test "user wants to edit an island - success" do
    island = create(:island)

    visit game_path(island.game)

    within "##{dom_id(island)}" do
      find(".ri-edit-line").click
    end

    fill_in "Name", with: "Better  Island"

    assert_changes "island.reload.name" do
      click_on "Speichern"

      assert_text "Better Island wurde aktualisiert."
    end
  end
end
