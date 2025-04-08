# frozen_string_literal: true

class Message < ApplicationRecord
  encrypts :content

  belongs_to :conversation, optional: false
  belongs_to :sender, polymorphic: true, optional: false

  STATUSES = [
    STATUS_PENDING = "pending",
    STATUS_SENT = "sent",
    STATUS_FAILED = "failed"
  ].freeze

  enum(:status, STATUSES.index_with { _1 })

  ROLES = [
    ROLE_USER = "user",
    ROLE_ASSISTANT = "assistant",
    ROLE_SYSTEM = "system"
  ].freeze

  enum(:role, ROLES.index_with { _1 })

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :role, presence: true, inclusion: { in: ROLES }
  validates :content, presence: true

  after_initialize :set_default_status

  private

  def set_default_status
    self.status ||= STATUS_PENDING
  end
end
