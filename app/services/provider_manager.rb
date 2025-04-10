# frozen_string_literal: true

class ProviderManager
  def initialize(conversation:)
    @conversation = conversation
  end

  delegate :call, to: :provider_instance

  private

  def provider_instance
    provider = conversation.use_case.provider

    case provider
    when "openai"
      Providers::OpenAi.new(conversation: conversation)
    when "gemini"
      raise NotImplementedError.new("Gemini client not implemented")
    else
      raise "Unsupported LLM provider: #{provider}"
    end
  end

  attr_reader :conversation
end
