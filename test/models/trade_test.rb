require "test_helper"

class TradeTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "destroys available good when goods for trade change" do
    trade = build(:trade)

    assert_difference "AvailableGood.count", 2 do
      perform_enqueued_jobs do
        trade.save!
      end
    end

    created_available_input_good = AvailableGood.find_by!(
      good: trade.input_good,
      island: trade.island
    )

    created_available_output_good = AvailableGood.find_by!(
      good: trade.output_good,
      island: trade.island
    )

    trade.input_good = create(:good)
    trade.output_good = create(:good)

    assert_no_difference "AvailableGood.count" do
      perform_enqueued_jobs do
        trade.save!
      end
    end

    assert_raises(ActiveRecord::RecordNotFound) { created_available_input_good.reload }
    assert_raises(ActiveRecord::RecordNotFound) { created_available_output_good.reload }
  end
end
