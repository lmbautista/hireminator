# frozen_string_literal: true

# test/lib/response_test.rb

require "test_helper"

class ResponseTest < ActiveSupport::TestCase
  test "success response returns true for success? and false for failure?" do
    result = Response.success("ok")

    assert result.success?
    assert_not result.failure?
    assert_equal "ok", result.value
    assert_nil result.error
  end

  test "failure response returns true for failure? and false for success?" do
    result = Response.failure("error")

    assert result.failure?
    assert_not result.success?
    assert_equal "error", result.error
    assert_nil result.value
  end

  test "and_then yields to block when success" do
    result = Response.success(2).and_then { |v| Response.success(v * 2) }

    assert result.success?
    assert_equal 4, result.value
  end

  test "and_then skips block when failure" do
    result = Response.failure("fail").and_then { |_| Response.success("should not run") }

    assert result.failure?
    assert_equal "fail", result.error
  end

  test "on_failure yields error when failure" do
    called = false

    Response.failure("error").on_failure do |e|
      called = true
      assert_equal "error", e
    end

    assert called
  end

  test "on_failure does not yield when success" do
    called = false

    Response.success("ok").on_failure do |_|
      called = true
    end

    assert_not called
  end

  test "on_success yields value when success" do
    called = false

    Response.success("value").on_success do |v|
      called = true
      assert_equal "value", v
    end

    assert called
  end

  test "on_success does not yield when failure" do
    called = false

    Response.failure("error").on_success do |_|
      called = true
    end

    assert_not called
  end
end
