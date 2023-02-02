require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "user wants to open existing game" do
    game = create(:game)

    visit root_path

    fill_in "name", with: "Rails system test"
    fill_in "game_id", with: game.id
    click_on "Öffnen"

    assert_text "SPIELVERWALTUNG"
    assert_text "Dein Name: Rails system test"
  end

  test "user wants to open non-existing game" do
    visit root_path

    fill_in "name", with: "Rails system test"
    fill_in "game_id", with: "non-existing-id"
    click_on "Öffnen"

    assert_text "Dieses Spiel existiert nicht."
  end

  test "user wants to open existing game without providing user name" do
    game = create(:game)

    visit root_path

    fill_in "game_id", with: game.id
    click_on "Öffnen"

    message = find_field("name").native.attribute("validationMessage")
    assert_equal "Please fill out this field.", message
  end

  test "user wants to open existing game without providing game id" do
    visit root_path

    fill_in "name", with: "hello world!"
    click_on "Öffnen"

    message = find_field("game_id").native.attribute("validationMessage")
    assert_equal "Please fill out this field.", message
  end

  test "user creates a new game" do
    visit root_path

    fill_in "name", with: "Rails system test"

    assert_difference "Game.count", 1 do
      click_on "Erstellen"
      assert_text "SPIELVERWALTUNG"
    end

    assert_text "Dein Name: Rails system test"
  end
end
