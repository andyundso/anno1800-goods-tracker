require "test_helper"

class LocalProducedGoodTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "destroys available good when produced good changes" do
    export = build(:export)

    assert_difference "AvailableGood.count", 2 do
      perform_enqueued_jobs do
        export.save!
      end
    end

    local_produced_good = export.local_produced_good

    available_good_production_island = AvailableGood.find_by!(
      good: local_produced_good.good,
      island: local_produced_good.island
    )

    available_good_import_island = AvailableGood.find_by!(
      good: local_produced_good.good,
      island: export.island
    )

    local_produced_good.good = create(:good)

    assert_no_difference "AvailableGood.count" do
      perform_enqueued_jobs do
        local_produced_good.save!
      end
    end

    assert_raises(ActiveRecord::RecordNotFound) { available_good_production_island.reload }
    assert_raises(ActiveRecord::RecordNotFound) { available_good_import_island.reload }
  end
end
