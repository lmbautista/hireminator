# frozen_string_literal: true

require "json"

class JsonExtractor
  def self.call(text)
    new(text).call
  end

  def initialize(text)
    @text = text
  end

  def call
    return Response.failure("No input provided") if text.blank?

    json_string = extract_json_string(text)
    return Response.failure("No JSON block found") unless json_string

    begin
      parsed = JSON.parse(json_string)
      Response.success(parsed)
    rescue JSON::ParserError => e
      Response.failure("JSON parse error: #{e.message}")
    end
  end

  private

  attr_reader :text

  def extract_json_string(text)
    text[/```json\s*(\{.*?\})\s*```/m, 1]
  end
end
