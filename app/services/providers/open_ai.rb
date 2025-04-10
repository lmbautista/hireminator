# frozen_string_literal: true

module Providers
  class OpenAi < Base
    private

    def client
      @client ||= OpenAI::Client
        .new(access_token: ENV.fetch("OPENAI_API_KEY"), log_errors: true)
    end

    def chat_with_provider(messages)
      response = client.chat(
        parameters: {
          model: use_case.model,
          temperature: use_case.temperature,
          messages: messages
        }
      )

      Rails.logger.debug ">>>>> OPEN AI response: "
      Rails.logger.debug response

      response.dig("choices", 0, "message")
    end
  end
end
