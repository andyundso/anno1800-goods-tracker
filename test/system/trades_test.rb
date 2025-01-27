require "application_system_test_case"

class TradesTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  test "user wants to add a trade - failure" do
    island = create(:island)

    visit game_path(island.game)

    within "##{dom_id(island)}" do
      find(".add-trade").click
    end

    assert_no_changes "Trade.count" do
      click_on "Speichern"

      assert_text "Eingabeware muss ausgefüllt werden"
    end
  end

  test "user wants to add a trade - success" do
    island = create(:island)
    input_good = create(:good)
    output_good = create(:good)

    visit game_path(island.game)

    within "##{dom_id(island)}" do
      find(".add-trade").click
    end

    select input_good.name_de, from: "trade_input_good_id"
    fill_in "Eingabemenge", with: 5000

    select output_good.name_de, from: "trade_output_good_id"
    fill_in "Ausgabemenge", with: 150

    assert_changes "Trade.count", 1 do
      perform_enqueued_jobs do
        click_on "Speichern"
      end

      assert_text "Speicherstadt-Handel erfolgreich erfasst."

      perform_enqueued_jobs
      perform_enqueued_jobs
    end

    # Ensure the available good gets produced
    within "#available_goods_#{island.id}" do
      assert_selector "turbo-frame", count: 2
    end
  end

  test "user wants to edit a trade" do
    trade = create(:trade)
    perform_enqueued_jobs

    available_good = AvailableGood.find_by(
      good_id: trade.input_good_id,
      island_id: trade.island_id
    )

    visit game_path(trade.game)

    find("##{dom_id(available_good)} img").click

    assert_text "#{available_good.good.name} auf #{available_good.island.name}"

    click_on "Handel anpassen"

    fill_in "Ausgabemenge", with: 42.0

    assert_changes "trade.reload.output_good_quantity", to: 42.0 do
      click_on "Speichern"

      assert_text "Speicherstadt-Handel wurde aktualisiert."
    end
  end

  test "user wants to delete trade" do
    trade = create(:trade)
    perform_enqueued_jobs

    available_good = AvailableGood.find_by(
      good_id: trade.input_good_id,
      island_id: trade.island_id
    )

    visit game_path(trade.game)

    find("##{dom_id(available_good)} img").click

    assert_text "#{available_good.good.name} auf #{available_good.island.name}"

    assert_difference "Trade.count", -1 do
      click_on "Löschen"

      assert_text "Speicherstadt-Handel gelöscht"
    end
  end
end
