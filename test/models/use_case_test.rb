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
end
