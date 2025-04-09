# frozen_string_literal: true

class Auditing
  def initialize(event:, initiator_data:, params: {})
    @event = event
    @initiator_data = initiator_data
    @context = params
  end

  def call(&block)
    audit_log = AuditLog.create!(
      event:,
      context:,
      status: AuditLog::STATUS_EXECUTING,
      initiator_id: initiator_data.id,
      initiator_format: initiator_data.format
    )

    begin
      result = block.call
      audit_log.update!(status: AuditLog::STATUS_SUCCESS)

      Response.success(result)
    rescue StandardError => e
      audit_log.update!(
        status: AuditLog::STATUS_FAILED,
        message: context.merge(error: e.message)
      )

      Response.failure(e.message)
    end
  end

  private

  attr_reader :event, :initiator_data, :context, :message
end
