require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "user wants to open existing game" do
    game = create(:game)

    visit root_path

    fill_in "game_id", with: game.id
    click_on "Öffnen"

    assert_text "SPIELVERWALTUNG"
  end

  test "user wants to open non-existing game" do
    visit root_path

    fill_in "game_id", with: "non-existing-id"
    click_on "Öffnen"

    assert_text "Dieses Spiel existiert nicht."
  end
end
