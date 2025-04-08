# frozen_string_literal: true

class Session < ApplicationRecord
  belongs_to :user, optional: false

  STATUSES = [
    STATUS_ACTIVE = "active",
    STATUS_EXPIRED = "expired",
    STATUS_CLOSED = "closed",
    STATUS_ERROR = "error"
  ].freeze

  enum(:status, STATUSES.index_with { _1 })

  validates :session_id, presence: true
  validates :status, inclusion: { in: STATUSES }
end
