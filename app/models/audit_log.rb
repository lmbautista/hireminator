# frozen_string_literal: true

class AuditLog < ApplicationRecord
  # TODO: implement status machine concern to ensure valid transitions between statuses
  INITIATOR_FORMATS = [
    INITIATOR_HUMAN = "human",
    INITIATOR_AI_AGENM = "ai-agent",
    INITIATOR_INTERNAL_PROCESM = "internal-process"
  ].freeze

  enum(:initiator_format, INITIATOR_FORMATS.index_with { _1 })

  STATUSES = [
    STATUS_SUCCESS = "success",
    STATUS_EXECUTING = "executing",
    STATUS_FAILED = "failed"
  ].freeze

  enum(:status, STATUSES.index_with { _1 })

  InitiatorData = Struct.new(:id, :format)

  validates :context, presence: true
  validates :event, presence: true
  validates :initiator_format, presence: true, inclusion: { in: initiator_formats.keys }
  validates :initiator_id, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
end
