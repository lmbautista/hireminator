# frozen_string_literal: true

require "test_helper"

module Providers
  class OpenAiTest < ActiveSupport::TestCase
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
        temperature: 0.6,
        purpose: UseCase::PURPOSE_INTERVIEW,
        initial_prompt: "Make three top questions of Ruby and Rails",
        locale: UseCase::LOCALE_EN
      )

      @conversation = Conversation.create!(
        user: @user,
        status: Conversation::STATUS_OPENED,
        use_case: @use_case
      )

      Message.create!(
        role: Message::ROLE_USER,
        content: "Hello",
        conversation: @conversation,
        sender: @user,
        status: Message::STATUS_SENT
      )

      Message.create!(
        role: Message::ROLE_ASSISTANT,
        content: "Hi! How can I help?",
        conversation: @conversation,
        sender: @user,
        status: Message::STATUS_SENT
      )

      @prompt = "Welcome! Let's begin."
      @role = "system"
    end

    # test "returns message content on success" do
    #   mock_client = Minitest::Mock.new
    #   mock_response = {
    #     "choices" => [
    #       { "message" => { "content" => "This is a test response." } }
    #     ]
    #   }

    #   mock_client.expect(:chat, mock_response, [{
    #                        parameters: {
    #                          model: @use_case.model,
    #                          temperature: @use_case.temperature,
    #                          messages: [
    #                            { role: "system", content: @prompt },
    #                            { role: "user", content: "Hello" },
    #                            { role: "assistant", content: "Hi! How can I help?" }
    #                          ]
    #                        }
    #                      }])

    #   OpenAI::Client.stub :new, mock_client do
    #     response = Providers::OpenAi.new(
    #       conversation: @conversation,
    #       prompt: @prompt,
    #       role: @role
    #     ).call

    #     debugger
    #     assert response.success?
    #     assert_equal "This is a test response.", response.value
    #   end

    #   mock_client.verify
    # end

    # test "returns failure response on error" do
    #   error = StandardError.new("Something went wrong")

    #   OpenAI::Client.stub :new, -> { raise error } do
    #     result = Providers::OpenAi.new(
    #       conversation: @conversation,
    #       prompt: @prompt,
    #       role: @role
    #     ).call

    #     assert result.failure?
    #     assert_equal "Something went wrong", result.error
    #   end
    # end
  end
end
