# frozen_string_literal: true

require "test_helper"

class MessageTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: "Wadus",
                         email: "wadus@hireminator-domain.com",
                         password: SecureRandom.uuid,
                         role: User::ROLE_RECRUITER)
    @use_case = UseCase.new(
      name: "Testing interview",
      provider: UseCase::PROVIDER_OPENAI,
      model: UseCase::MODEL_GPT4,
      purpose: UseCase::PURPOSE_INTERVIEW,
      initial_prompt: "Make three top questions of Ruby and Rails",
      locale: UseCase::LOCALE_EN
    )
    @conversation = Conversation.new(user: @user,
                                     status: Conversation::STATUS_OPENED,
                                     use_case: @use_case)
  end

  test "valid with required fields" do
    message = Message.new(
      conversation: @conversation,
      sender: @user,
      status: Message::STATUS_SENT,
      role: Message::ROLE_USER,
      content: "Hey, can I help you?"
    )
    assert message.valid?
  end

  test "invalid when no role provided" do
    message = Message.new(
      conversation: @conversation,
      sender: @user,
      status: Message::STATUS_SENT,
      content: "Hey, can I help you?"
    )

    assert_not message.valid?
    assert message.errors.added?(:role, :blank)
  end

  test "invalid when no content provided" do
    message = Message.new(
      conversation: @conversation,
      sender: @user,
      status: Message::STATUS_SENT,
      role: Message::ROLE_USER
    )

    assert_not message.valid?
    assert message.errors.added?(:content, :blank)
  end

  test "invalid when not supported status" do
    assert_raises ArgumentError do
      Message.new(
        conversation: @conversation,
        sender: @user,
        status: "unknown",
        role: Message::ROLE_USER,
        content: "test"
      )
    end
  end

  test "invalid when not supported role" do
    assert_raises ArgumentError do
      Message.new(
        conversation: @conversation,
        sender: @user,
        status: Message::STATUS_SENT,
        role: "unknown",
        content: "test"
      )
    end
  end
end
