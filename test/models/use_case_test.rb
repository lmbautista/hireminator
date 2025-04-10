# frozen_string_literal: true

require "test_helper"

class UseCaseTest < ActiveSupport::TestCase
  def setup
    @valid_attrs = {
      name: "Testing interview",
      purpose: UseCase::PURPOSE_INTERVIEW,
      provider: UseCase::PROVIDER_OPENAI,
      locale: UseCase::LOCALE_ES,
      model: UseCase::MODEL_GPT4,
      temperature: 0.6
    }
  end

  test "valid" do
    use_case = UseCase.new(@valid_attrs)

    assert use_case.valid?
  end

  test "invalid without initial_prompt" do
    use_case = UseCase.new(purpose: UseCase::PURPOSE_INTERVIEW, name: "Testing interviews")
    use_case.initial_prompt = nil

    assert_not use_case.valid?
    assert use_case.errors.added?(:initial_prompt, :blank)
  end

  test "invalid without model" do
    use_case = UseCase.new(purpose: UseCase::PURPOSE_INTERVIEW, name: "Testing interviews")

    assert_not use_case.valid?
    assert use_case.errors.added?(:model, :blank)
  end

  test "invalid without provider" do
    use_case = UseCase.new(purpose: UseCase::PURPOSE_INTERVIEW, name: "Testing interviews")

    assert_not use_case.valid?
    assert use_case.errors.added?(:provider, :blank)
  end

  test "invalid without name" do
    use_case = UseCase.new(initial_prompt: "Testing random things",
                           purpose: UseCase::PURPOSE_INTERVIEW)

    assert_not use_case.valid?
    assert use_case.errors.added?(:name, :blank)
  end

  test "invalid without temperature" do
    use_case = UseCase.new(purpose: UseCase::PURPOSE_INTERVIEW, name: "Testing interviews")
    use_case.temperature = nil

    assert_not use_case.valid?
    assert use_case.errors.added?(:temperature, :blank)
  end

  test "should raise error on invalid purpose" do
    assert_raises ArgumentError do
      UseCase.new(name: "Testing interviews", purpose: "unknown",
                  initial_prompt: "Testing random things")
    end
  end

  test "full_name returns correct value" do
    use_case = UseCase.new(@valid_attrs)
    expected_full_name = "EN - Testing interview"

    assert_equal expected_full_name, use_case.send(:full_name)
  end

  test "set prompts properly" do
    use_case = UseCase.new(@valid_attrs)

    %w(initial_prompt resume_prompt final_prompt extraction_prompt).each do |prompt_type|
      prompt = use_case.send(prompt_type.to_sym)

      assert prompt.present?, "Fails for #{prompt_type}"
      assert prompt["system"].present?, "Fails for #{prompt_type}"
      assert prompt["user"].present?, "Fails for #{prompt_type}"
    end
  end

  test "goodbye_key_prompt" do
    use_case = UseCase.new(@valid_attrs)
    expected_prompt = I18n.t("use_cases.#{use_case.purpose}.initial_prompt.goodbye_key",
                             locale: use_case.locale)

    assert_equal expected_prompt, use_case.goodbye_key_prompt
  end
end
