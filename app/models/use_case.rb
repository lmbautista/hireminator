# frozen_string_literal: true

class UseCase < ApplicationRecord
  has_many :conversations

  PURPOSES = [
    PURPOSE_INTERVIEW = "interview",
    PURPOSE_DOC_REQUEST = "documentation_request",
    PURPOSE_SUPPORT = "support"
  ].freeze

  enum(:purpose, PURPOSES.index_with { _1 })

  # We should extract it into a dedicated static model to bring strong convention
  LOCALES = [
    LOCALE_ES = "es",
    LOCALE_EN = "en",
    LOCALE_FR = "fr"
  ].freeze

  enum(:locale, LOCALES.index_with { _1 })

  MODELS = [
    MODEL_GPT4_TURBO = "gpt-4-turbo",
    MODEL_GPT4 = "gpt-4",
    MODEL_GPT4_MINI = "gpt-4o-mini",
    MODEL_GPT3_5_TURBO = "gpt-3.5-turbo"
  ].freeze

  enum(:model, MODELS.index_with { _1 })

  PROVIDERS = [PROVIDER_OPENAI = "openai", PROVIDER_GEMINI = "gemini"].freeze

  enum(:provider, PROVIDERS.index_with { _1 })

  DEFAULT_TEMPERATURE = 0.7

  validates :name, presence: true, uniqueness: true
  validates :provider, presence: true, inclusion: { in: PROVIDERS }
  validates :model, presence: true, inclusion: { in: MODELS }
  validates :temperature, presence: true, numericality: {
    only_float: true,
    greater_than_or_equal_to: 0.0,
    less_than_or_equal_to: 1.0
  }
  validates :purpose, presence: true, inclusion: { in: PURPOSES }
  validates :locale, presence: true, inclusion: { in: LOCALES }
  validates :initial_prompt, presence: true

  after_initialize :set_prompts

  def goodbye_key_prompt
    I18n.t("use_cases.#{purpose}.initial_prompt.goodbye_key", locale:)
  end

  def full_name
    return if name.blank?

    [locale.upcase, name].join(" - ")
  end

  private

  def set_prompts
    self.name ||= full_name
    self.initial_prompt ||= build_initial_prompt.as_json
    self.resume_prompt ||= build_resume_prompt.as_json
    self.final_prompt ||= build_final_prompt.as_json
    self.extraction_prompt ||= build_extraction_prompt.as_json
    self.temperature ||= DEFAULT_TEMPERATURE
  end

  def build_initial_prompt
    prompt_key = prompt_for(:initial)
    system_prompt = I18n.t("#{prompt_key}.system", locale:, inputs: inputs.to_json,
                                                   outputs: outputs.to_json)
    user_prompt = I18n.t("#{prompt_key}.user", locale:)

    { system: system_prompt, user: user_prompt }.compact
  end

  def build_resume_prompt
    prompt_key = prompt_for(:resume)
    system_prompt = I18n.t("#{prompt_key}.system", locale:)
    user_prompt = I18n.t("#{prompt_key}.user", locale:)

    { system: system_prompt, user: user_prompt }.compact
  end

  def build_final_prompt
    prompt_key = prompt_for(:final)
    system_prompt = I18n.t("#{prompt_key}.system", locale:)
    user_prompt = I18n.t("#{prompt_key}.user", locale:)

    { system: system_prompt, user: user_prompt }.compact
  end

  def build_extraction_prompt
    prompt_key = prompt_for(:extraction)
    system_prompt = I18n.t("#{prompt_key}.system", locale:, outputs: outputs.to_json)
    user_prompt = I18n.t("#{prompt_key}.user", locale:)

    { system: system_prompt, user: user_prompt }.compact
  end

  def prompt_for(prompt_type)
    "use_cases.#{purpose}.#{prompt_type}_prompt"
  end
end
