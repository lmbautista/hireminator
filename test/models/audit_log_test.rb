# frozen_string_literal: true

require "test_helper"

class AuditLogTest < ActiveSupport::TestCase
  test "valid" do
    log = AuditLog.new(
      event:,
      status: AuditLog::STATUS_SUCCESS,
      initiator_id: "wadus@gmail.com",
      initiator_format: AuditLog::INITIATOR_HUMAN,
      context: { example: "data" }
    )

    assert log.valid?
  end

  test "invalid when no status" do
    log = AuditLog.new(status: nil)

    assert_not log.valid?
    assert log.errors.added?(:status, :blank)
  end

  test "invalid when no initiator_id" do
    log = AuditLog.new(initiator_id: nil)

    assert_not log.valid?
    assert log.errors.added?(:initiator_id, :blank)
  end

  test "invalid when no initiator_format" do
    log = AuditLog.new(initiator_format: nil)

    assert_not log.valid?
    assert log.errors.added?(:initiator_format, :blank)
  end

  test "invalid when not supported initiator_format" do
    log = AuditLog.new(initiator_format: "wadus")

    assert_not log.valid?
    assert log.errors.added?(:initiator_format, :inclusion, value: "wadus")
  end

  test "invalid when no event" do
    log = AuditLog.new(status: AuditLog::STATUS_SUCCESS, context: {})

    assert_not log.valid?
    assert log.errors.added?(:event, :blank)
  end

  test "invalid when not supported status" do
    assert_raises ArgumentError do
      AuditLog.new(status: "invalid", event:)
    end
  end

  test "provides InitiatorData interface" do
    expected_format = AuditLog::INITIATOR_HUMAN
    initiator_data = AuditLog::InitiatorData.new(user_email, expected_format)

    assert_equal user_email, initiator_data.id
    assert_equal expected_format, initiator_data.format
  end

  private

  UserMock = Struct.new(:id, :type, :email)
  private_constant :UserMock

  def user_email
    "wadus@hireminator-domain.com"
  end

  def event
    @event ||= "the_event"
  end
end
