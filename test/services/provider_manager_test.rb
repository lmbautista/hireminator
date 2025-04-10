# frozen_string_literal: true

require "test_helper"

class ProviderManagerTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      name: "Wadus",
      email: "wadus@example.com",
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
      use_case: @use_case,
      status: Conversation::STATUS_OPENED
    )
  end

  test "returns result from provider when provider is openai" do
    mock_provider = Minitest::Mock.new
    mock_provider.expect :call, Response.success("Hi there")

    Providers::OpenAi.expects(:new).returns(mock_provider)

    manager = ProviderManager.new(conversation: @conversation)

    result = manager.call
    assert result.success?
    assert_equal "Hi there", result.value

    mock_provider.verify
  end

  test "raises NotImplementedError for gemini provider" do
    @use_case.update!(provider: "gemini")

    manager = ProviderManager.new(conversation: @conversation)

    assert_raises(NotImplementedError) { manager.call }
  end
end
