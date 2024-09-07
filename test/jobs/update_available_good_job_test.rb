require "test_helper"

class UpdateAvailableGoodJobTest < ActiveJob::TestCase
  test "should create an available good" do
    produced_good = create(:local_produced_good)

    assert_enqueued_with(job: UpdateAvailableGoodJob)
    perform_enqueued_jobs

    available_good = AvailableGood.last

    assert_equal produced_good.consumption, available_good.consumption
    assert_equal produced_good.production, available_good.production
  end

  test "should update an available good" do
    good = create(:good)
    island = create(:island)

    available_good = create(:available_good, good: good, island: island)
    produced_good = create(:local_produced_good, good: good, island: island)

    assert_enqueued_with(job: UpdateAvailableGoodJob)
    perform_enqueued_jobs

    assert_equal produced_good.consumption, available_good.reload.consumption
    assert_equal produced_good.production, available_good.production
  end

  test "should destroy an available good" do
    available_good = create(:available_good)

    assert_difference "AvailableGood.count", -1 do
      perform_enqueued_jobs do
        UpdateAvailableGoodJob.perform_now(available_good.island_id, available_good.good_id)
      end
    end
  end

  test "should calculate with input good on island" do
    original_good = create(:good)
    output_good = create(:local_produced_good)
    input_good = create(:input_good, input_good: original_good, output_good: output_good)

    assert_enqueued_with(job: UpdateAvailableGoodJob)
    perform_enqueued_jobs

    available_good = AvailableGood.order(created_at: :desc).first

    assert_equal input_good.input_good_id, available_good.good_id
    assert_equal output_good.production, available_good.local_usage
  end

  test "should calculate with export good to island" do
    export = create(:export)

    perform_enqueued_jobs do
      UpdateAvailableGoodJob.perform_now(export.island_id, export.good.id)
      UpdateAvailableGoodJob.perform_now(export.local_produced_good.island_id, export.good.id)
    end

    # check for export on production island
    available_good = AvailableGood.find_by!(
      good_id: export.good.id,
      island_id: export.local_produced_good.island_id
    )

    assert_equal export.quantity, available_good.export

    # check for import on target island
    available_good = AvailableGood.find_by!(
      good_id: export.good.id,
      island_id: export.island_id
    )

    assert_equal export.quantity, available_good.import
  end
end
