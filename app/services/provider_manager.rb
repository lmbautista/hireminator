# frozen_string_literal: true

class ProviderManager
  def self.build(conversation:, prompt:, role:)
    provider = conversation.use_case.provider
    case conversation.use_case.provider
    when "openai"
      Providers::OpenAi.new(conversation:, prompt:, role:)
    when "anthropic"
      raise NotImplementedError.new("Anthropic client not implemented")
    when "mistral"
      raise NotImplementedError.new("Mistral client not implemented")
    else
      raise "Unsupported LLM provider: #{provider}"
    end
  end
end
