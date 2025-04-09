# frozen_string_literal: true

module Providers
  class OpenAi < Base
    private

    def history_messages
      conversation.public_messages.order(:created_at).map do |message|
        { role: message.role, content: message.content }
      end
    end

    def client
      @client ||= OpenAI::Client
        .new(access_token: ENV.fetch("OPENAI_API_KEY"), log_errors: true)
    end

    def chat_with_provider(message)
      response = client.chat(
        parameters: {
          model: use_case.model,
          temperature: use_case.temperature,
          messages: [{ role: message.role, content: message.content }, *history_messages]
        }
      )

      content = response.dig("choices", 0, "message", "content")
      Response.success(content)
    rescue StandardError => e
      Response.failure(e.message)
    end

    private

    attr_reader :client, :conversation, :prompt, :role

    delegate :use_case, to: :conversation

    def history_messages
      conversation.messages.order(:created_at).map do |message|
        { role: message.role, content: message.content }
      end
    end
  end
end
