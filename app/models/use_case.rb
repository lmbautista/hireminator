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
    MODEL_GPT3_5_TURBO = "gpt-3.5-turbo"
  ].freeze

  enum(:model, MODELS.index_with { _1 })

  PROVIDERS = [PROVIDER_OPENAI = "openai"].freeze

  enum(:provider, PROVIDERS.index_with { _1 })

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
end
