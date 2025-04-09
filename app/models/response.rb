# frozen_string_literal: true

class Response
  attr_reader :value, :error

  def initialize(success:, value: nil, error: nil)
    @success = success
    @value = value
    @error = error
  end

  def self.success(value = nil)
    new(success: true, value: value)
  end

  def self.failure(error)
    new(success: false, error: error)
  end

  def success?
    @success
  end

  def failure?
    !success?
  end

  def and_then
    return self if failure?

    yield(value)
  end

  def on_failure
    yield(error) if failure?
    self
  end

  def on_success
    yield(value) if success?
    self
  end
end
