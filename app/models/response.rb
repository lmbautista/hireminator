# frozen_string_literal: true

class Response
  attr_reader :value

  def initialize(success:, value: nil)
    @success = success
    @value = value
  end

  def self.success(value = nil)
    new(success: true, value: value)
  end

  def self.failure(error)
    new(success: false, value: error)
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
    yield(value) if failure?
    self
  end

  def on_success
    yield(value) if success?
    self
  end
end
