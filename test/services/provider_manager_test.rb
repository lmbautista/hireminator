# frozen_string_literal: true

# test/lib/provider_manager_test.rb
require "test_helper"

class ProviderManagerTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      name: "Luismi",
      email: "luismi@hireminator.com",
      password: SecureRandom.uuid,
      role: User::ROLE_RECRUITER
    )

    @use_case = UseCase.create!(
      name: "Interview",
      provider: UseCase::PROVIDER_OPENAI,
      model: UseCase::MODEL_GPT4,
      temperature: 0.7,
      purpose: UseCase::PURPOSE_INTERVIEW,
      locale: UseCase::LOCALE_EN
    )

    @conversation = Conversation.create!(
      user: @user,
      status: Conversation::STATUS_OPENED,
      use_case: UseCase.create!(
        name: "Test case",
        provider: "openai",
        model: "gpt-4",
        temperature: 0.7,
        purpose: UseCase::PURPOSE_INTERVIEW,
        initial_prompt: "Hello",
        lang: "en"
      )
    )

    @prompt = "Start prompt"
    @role = "system"
  end

  test "returns OpenAi provider when use_case provider is 'openai'" do
    provider = ProviderManager.build(
      conversation: @conversation,
      prompt: @prompt,
      role: @role
    )

    assert_instance_of Providers::OpenAi, provider
  end

  test "raises generic error on unsupported provider" do
    @conversation.use_case.assign_attributes(provider: "gemini")

    error = assert_raises(RuntimeError) do
      ProviderManager.build(conversation: @conversation, prompt: @prompt, role: @role)
    end

    assert_match(/Unsupported LLM provider/, error.message)
  end
end
