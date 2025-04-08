# frozen_string_literal: true

require "test_helper"

class AuditingTest < ActiveSupport::TestCase
  def setup
    @event = "the_event"
    @initiator_data = AuditLog::InitiatorData.new(
      "wadus@hireminator-domain.com",
      AuditLog::INITIATOR_HUMAN
    )
    @params = { action: "test_action", param_one: "param_test" }
  end

  test "creates audit successfully in executing status" do
    wrapper = Auditing.new(
      event: @event,
      params: @params,
      initiator_data: @initiator_data
    )

    audit_log = nil

    assert_difference -> { AuditLog.count }, 1 do
      wrapper.call do
        audit_log = AuditLog.last

        assert_equal "executing", audit_log.status
        assert_equal @params.as_json, audit_log.context

        true
      end
    end
  end

  test "creates audit successfully when block success" do
    result = nil

    assert_difference -> { AuditLog.count }, 1 do
      response = Auditing.new(
        event: @event,
        params: @params,
        initiator_data: @initiator_data
      ).call do
        "expected result"
      end
    end

    audit_log = AuditLog.last

    assert_equal "success", audit_log.status
    assert_equal "expected result", result
  end

  test "creates audit successfully when block fails" do
    assert_difference -> { AuditLog.count }, 1 do
      response = Auditing.new(
        event: @event,
        params: @params,
        initiator_data: @initiator_data
      ).call do
        raise StandardError.new("Something went wrong")
      end
    end

    audit_log = AuditLog.last

    assert_equal "failed", audit_log.status
    assert_match(/Something went wrong/, audit_log.message)
  end
end
