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
end
