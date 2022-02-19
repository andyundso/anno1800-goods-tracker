require "test_helper"

class UpdateAvailableGoodJobTest < ActiveJob::TestCase
  test "should create an available good" do
    produced_good = create(:local_produced_good)

    assert_difference "AvailableGood.count" do
      UpdateAvailableGoodJob.perform_now(produced_good.island_id, produced_good.good_id)
    end

    available_good = AvailableGood.last

    assert_equal produced_good.consumption, available_good.consumption
    assert_equal produced_good.production, available_good.production
  end

  test "should update an available good" do
    good = create(:good)
    island = create(:island)

    produced_good = create(:local_produced_good, good: good, island: island)
    available_good = create(:available_good, good: good, island: island)

    UpdateAvailableGoodJob.perform_now(produced_good.island_id, produced_good.good_id)

    assert_equal produced_good.consumption, available_good.reload.consumption
    assert_equal produced_good.production, available_good.production
  end

  test "should destroy an available good" do
    available_good = create(:available_good)

    assert_difference "AvailableGood.count", -1 do
      UpdateAvailableGoodJob.perform_now(available_good.island_id, available_good.good_id)
    end
  end
end
