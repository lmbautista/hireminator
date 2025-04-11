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
      response = wrapper.call do
        audit_log = AuditLog.last

        assert_equal "executing", audit_log.status
        assert_equal @params.as_json, audit_log.context

        Response.success("expected done")
      end

      assert response.success?
      assert_kind_of String, response.value
    end
  end

  test "creates audit successfully when block success" do
    assert_difference -> { AuditLog.count }, 1 do
      response = Auditing.new(
        event: @event,
        params: @params,
        initiator_data: @initiator_data
      ).call do
        Response.success("expected result")
      end

      audit_log = AuditLog.last

      assert response.success?
      assert_equal "success", audit_log.status
      assert_equal "expected result", response.value
    end
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

      audit_log = AuditLog.last

      assert response.failure?
      assert_equal "Something went wrong", response.value
      assert_equal "failed", audit_log.status
      assert_match(/Something went wrong/, audit_log.message)
    end
  end
end
