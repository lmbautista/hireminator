# frozen_string_literal: true

class Conversation < ApplicationRecord
  encrypts :inputs
  encrypts :outputs

  belongs_to :user, optional: false
  belongs_to :use_case, optional: false
  has_many :messages, dependent: :destroy

  STATUSES = [
    STATUS_ABANDONED = "abandoned",
    STATUS_ARCHIVED = "archived",
    STATUS_CLOSED = "closed",
    STATUS_COMPLETED = "completed",
    STATUS_OPENED = "opened"
  ].freeze

  enum(:status, STATUSES.index_with { _1 })

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :ended_at, presence: true, if: :completed?
  validates :full_transcript, presence: true, if: :completed?
end
