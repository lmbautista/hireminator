# frozen_string_literal: true

require "test_helper"

class SessionTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: "Wadus",
                         email: "wadus@hireminator-domain.com",
                         password: SecureRandom.uuid,
                         role: User::ROLE_CANDIDATE)
  end

  test "valid" do
    session = Session.new(user: @user, session_id: "abc123", status: Session::STATUS_ACTIVE)

    assert session.valid?
  end

  test "should require session_id" do
    session = Session.new(user: @user, status: "active")

    assert_not session.valid?
    assert session.errors.added?(:session_id, :blank)
  end

  test "should raise error on invalid status" do
    assert_raises ArgumentError do
      Session.new(user: @user, session_id: "x", status: "boom")
    end
  end
end
