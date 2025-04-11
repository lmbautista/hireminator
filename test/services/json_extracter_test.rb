# frozen_string_literal: true

# test/services/extract_json_from_text_test.rb
require "test_helper"

class JsonExtractorTest < ActiveSupport::TestCase
  test "parses a valid JSON block successfully" do
    text = <<~TEXT
      Here is the structured data:

      ```json
      {
        "full_name": "Luismi Bautisat",
        "city": "Fuenlabrada"
      }
      ```
    TEXT

    result = JsonExtractor.call(text)

    assert result.success?
    assert_equal "Luismi Bautisat", result.value["full_name"]
    assert_equal "Fuenlabrada", result.value["city"]
  end

  test "returns failure when no JSON block is present" do
    text = "There is no JSON here."

    result = JsonExtractor.call(text)

    assert_not result.success?
    assert_match(/No JSON block/, result.value)
  end

  test "returns failure when JSON is invalid" do
    text = <<~TEXT
      ```json
      {
        "invalid": true,
      }
      ```
    TEXT

    result = JsonExtractor.call(text)

    assert_not result.success?
    assert_match(/JSON parse error/, result.value)
  end

  test "returns failure when input is blank" do
    result = JsonExtractor.call("")

    assert_not result.success?
    assert_match(/No input provided/, result.value)
  end
end
