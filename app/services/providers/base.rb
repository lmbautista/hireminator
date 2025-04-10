# frozen_string_literal: true

module Providers
  class Base
    def initialize(conversation:)
      @client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"), log_errors: true)
      @conversation = conversation
    end

    def call(messages)
      response = chat_with_provider(messages)
      Response.success(response)
    rescue StandardError => e
      Response.failure(e.message)
    end

    private

    attr_reader :conversation, :message

    delegate :use_case, to: :conversation

    def client
      raise NotImplementedError.new("You must implement the client method")
    end

    def chat_with_provider(_messages)
      raise NotImplementedError.new("You must implement the chat_with_provider method")
    end
  end
end
