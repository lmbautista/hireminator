# frozen_string_literal: true

# test/services/chat_test.rb
require "test_helper"

class ChatTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      name: "Wadus",
      email: "wadus@hireminator-domain.com",
      password: SecureRandom.uuid,
      role: User::ROLE_RECRUITER
    )

    @use_case = UseCase.create!(
      name: "Testing interview",
      provider: UseCase::PROVIDER_OPENAI,
      model: UseCase::MODEL_GPT4,
      purpose: UseCase::PURPOSE_INTERVIEW,
      locale: UseCase::LOCALE_EN,
      initial_prompt: { user: "Hi", system: "Be nice" },
      final_prompt: { user: "Thanks", system: "Bye" },
      extraction_prompt: { user: "Extract this", system: "Data" },
      resume_prompt: { user: "Resume?", system: "Sure" }
    )

    @conversation = Conversation.new(user: @user, status: Conversation::STATUS_OPENED,
                                     use_case: @use_case)
    @message_content = "Estoy interesado en la oferta."

    @client_mock = mock("client")
    ProviderManager.stubs(:new).returns(@client_mock)

    Conversation.stubs(:in_progress).returns(stub(find_by: @conversation))
    @conversation.stubs(:with_lock).yields
  end

  test "runs full conversation flow successfully" do
    @conversation.stubs(:can_be_resumed?).returns(true)
    @conversation.stubs(:can_be_started?).returns(true)
    @conversation.stubs(:can_be_finished?).returns(true)
    @conversation.stubs(:can_be_archived?).returns(true)
    @conversation.stubs(:update!)

    Message.stubs(:create!).returns(build_message)

    @client_mock.stubs(:call).returns(Response.success({ role: "assistant",
                                                         content: '{"full_name":"Luismi"}' }))
    JsonExtractor.stubs(:call).returns(Response.success({ full_name: "Luismi" }))

    result = Chat.new(use_case: @use_case, user: @user, message_content: @message_content).call

    assert result.success?
    assert_kind_of Conversation, result.value
  end

  test "skips resume and starts conversation if resume not allowed" do
    @conversation.stubs(:can_be_resumed?).returns(false)
    @conversation.stubs(:can_be_started?).returns(true)
    @conversation.stubs(:can_be_finished?).returns(false)
    @conversation.stubs(:can_be_archived?).returns(false)

    Message.stubs(:create!).returns(build_message)
    @client_mock.stubs(:call).returns(Response.success({ role: "assistant", content: "whatever" }))

    result = Chat.new(use_case: @use_case, user: @user, message_content: @message_content).call

    assert result.success?
  end

  test "handles archive with valid json response" do
    @conversation.stubs(:can_be_resumed?).returns(false)
    @conversation.stubs(:can_be_started?).returns(false)
    @conversation.stubs(:can_be_finished?).returns(false)
    @conversation.stubs(:can_be_archived?).returns(true)
    @conversation.stubs(:update!)

    Message.stubs(:create!).returns(build_message(content: '{"full_name":"Luismi"}'))
    @client_mock.stubs(:call).returns(Response.success({ role: "assistant",
                                                         content: '{"full_name":"Luismi"}' }))
    JsonExtractor.stubs(:call).returns(Response.success({ full_name: "Luismi" }))

    result = Chat.new(use_case: @use_case, user: @user, message_content: "").call

    assert result.success?
  end

  test "returns failure if client fails" do
    @conversation.stubs(:can_be_resumed?).returns(true)
    @conversation.stubs(:can_be_started?).returns(false)
    @conversation.stubs(:can_be_finished?).returns(false)
    @conversation.stubs(:can_be_archived?).returns(false)

    Message.stubs(:create!).returns(build_message)
    @client_mock.stubs(:call).returns(Response.failure("Boom"))

    result = Chat.new(use_case: @use_case, user: @user, message_content: @message_content).call

    assert_not result.success?
    assert_match(/Boom/, result.value)
  end

  private

  def build_message(attrs = {})
    default_attrs = {
      conversation: @conversation,
      sender: @user,
      status: Message::STATUS_PENDING,
      role: Message::ROLE_ASSISTANT,
      content: "Generated message"
    }.merge(attrs)

    Message.new(default_attrs)
  end
end
