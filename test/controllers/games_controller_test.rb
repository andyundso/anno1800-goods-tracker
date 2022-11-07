require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  test "#new" do
    get new_game_path

    assert_response :success
  end

  test "#show" do
    game = create(:game)

    get game_path(game.id)

    assert_response :success
  end
end
