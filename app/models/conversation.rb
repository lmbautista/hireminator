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

  scope :in_progress, -> { where(status: [STATUS_ABANDONED, STATUS_CLOSED, STATUS_OPENED]) }
  scope :public_messages, -> { joins(:messages).where(messages: { system_generated: false }) }

  def public_messages
    messages.where(system_generated: false)
  end

  def next_conversation_step
    return :start_conversation unless persisted?

    case status
    when STATUS_ABANDONED, STATUS_CLOSED
      :resume_conversation
    when STATUS_OPENED
      :continue_conversation
    when STATUS_OPENED
      :continue_conversation
    else
      :nothing
    end
  end

  def can_be_resumed?
    [STATUS_ABANDONED, STATUS_CLOSED].include?(status)
  end

  def can_be_started?
    opened? && messages.count.zero?
  end

  def can_be_finished?
    regexp = Regexp.new(Regexp.escape(use_case.goodbye_key_prompt), Regexp::IGNORECASE)
    opened? && public_messages.any? { |m| m.content =~ regexp }
  end

  def can_be_archived?
    completed?
  end
end
