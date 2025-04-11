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
    @message = Message.new(
      conversation: @conversation,
      sender: @user,
      status: Message::STATUS_SENT,
      role: Message::ROLE_USER,
      content: "seguimos en contacto"
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

  test "returns :resume_conversation when status is abandoned" do
    conversation = Conversation.new(status: Conversation::STATUS_ABANDONED)
    conversation.stubs(:persisted?).returns(true)

    assert_equal :resume_conversation, conversation.next_conversation_step
  end

  test "returns :starts_conversation when conversation is not persisted" do
    conversation = Conversation.new

    assert_equal :start_conversation, conversation.next_conversation_step
  end

  test "returns :resume_conversation when status is closed" do
    conversation = Conversation.new(status: Conversation::STATUS_CLOSED)
    conversation.stubs(:persisted?).returns(true)

    assert_equal :resume_conversation, conversation.next_conversation_step
  end

  test "returns :continue_conversation when status is opened" do
    conversation = Conversation.new(status: Conversation::STATUS_OPENED)
    conversation.stubs(:persisted?).returns(true)

    assert_equal :continue_conversation, conversation.next_conversation_step
  end

  test "returns :nothing for unknown status" do
    conversation = Conversation.new(status: Conversation::STATUS_ARCHIVED)
    conversation.stubs(:persisted?).returns(true)

    assert_equal :nothing, conversation.next_conversation_step
  end

  test "can be resumed when abandoned" do
    conversation = Conversation.new(status: Conversation::STATUS_ABANDONED)

    assert conversation.can_be_resumed?
  end

  test "can be resumed when closed" do
    conversation = Conversation.new(status: Conversation::STATUS_CLOSED)

    assert conversation.can_be_resumed?
  end

  test "can be started" do
    conversation = Conversation.new(status: Conversation::STATUS_OPENED)

    assert conversation.can_be_started?
  end

  test "can be finished when opened and message includes goodbye key" do
    conversation = Conversation.new(status: Conversation::STATUS_OPENED, use_case: @use_case)
    conversation.stubs(:persisted?).returns(true)
    @message.stubs(:content).returns("Perfecto, seguimos en contacto. ¡Gracias!")

    conversation.messages << @message
    conversation.stubs(:public_messages).returns([@message])

    assert conversation.can_be_finished?
  end

  test "cannot be finished if status is not opened" do
    conversation = Conversation.new(status: Conversation::STATUS_COMPLETED, use_case: @use_case)
    conversation.stubs(:persisted?).returns(true)
    @message.stubs(:content).returns("Perfecto, seguimos en contacto. ¡Gracias!")

    conversation.messages << @message
    conversation.stubs(:public_messages).returns([@message])

    assert_not conversation.can_be_finished?
  end

  test "cannot be finished if no message matches goodbye key" do
    conversation = Conversation.new(status: Conversation::STATUS_OPENED, use_case: @use_case)
    conversation.stubs(:persisted?).returns(true)

    assert_not conversation.can_be_finished?
  end

  test "can be finished with different case in goodbye key" do
    conversation = Conversation.new(status: Conversation::STATUS_OPENED, use_case: @use_case)
    conversation.stubs(:persisted?).returns(true)

    @message.stubs(:content).returns("perfecto, seguimos en contacto. hasta pronto!")
    conversation.stubs(:public_messages).returns([@message])

    assert conversation.can_be_finished?
  end

  test "cannot be finished if there are no messages" do
    conversation = Conversation.new(status: Conversation::STATUS_OPENED, use_case: @use_case)
    message.stubs(:content).returns("seguimos en contacto")

    assert_not conversation.can_be_finished?
  end
end
