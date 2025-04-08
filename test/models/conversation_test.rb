# frozen_string_literal: true

require "test_helper"

class ConversationTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: "Wadus",
                         email: "wadus@hireminator-domain.com",
                         password: SecureRandom.uuid,
                         role: User::ROLE_RECRUITER)
    @use_case = UseCase.new(
      name: "Testing interview",
      purpose: UseCase::PURPOSE_INTERVIEW,
      locale: UseCase::LOCALE_ES
    )
    )
  end

  test "valid" do
    conversation = Conversation.new(user: @user,
                                    status: Conversation::STATUS_OPENED,
                                    use_case: @use_case)

    assert conversation.valid?
  end

  test "should require status" do
    conversation = Conversation.new(user: @user)

    assert_not conversation.valid?
    assert conversation.errors.added?(:status, :blank)
  end

  test "should require ended_at when completed" do
    conversation = Conversation.new(user: @user, status: Conversation::STATUS_COMPLETED)

    assert_not conversation.valid?
    assert conversation.errors.added?(:ended_at, :blank)
  end

  test "should raise error on invalid status" do
    assert_raises ArgumentError do
      Conversation.new(user: @user, status: "unknown")
    end
  end

  test "should require ended_at if status is completed" do
    conversation = Conversation.new(
      user: @user,
      status: "completed",
      full_transcript: "Some transcript"
    )

    assert_not conversation.valid?
    assert conversation.errors.added?(:ended_at, :blank)
  end

  test "should require full_transcript if status is completed" do
    conversation = Conversation.new(
      user: @user,
      status: "completed",
      ended_at: Time.current
    )

    assert_not conversation.valid?
    assert conversation.errors.added?(:full_transcript, :blank)
  end
end
