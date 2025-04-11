# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @valid_attrs = { name: "Wadus",
                     email: "wadus@hireminator-domain.com",
                     password: SecureRandom.uuid,
                     role: User::ROLE_CANDIDATE }
  end

  test "valid" do
    user = User.new(@valid_attrs)

    assert user.valid?
  end

  test "to_initiator_data" do
    user = User.new(@valid_attrs)
    expected_initiator_data = AuditLog::InitiatorData.new(user.email, AuditLog::INITIATOR_HUMAN)

    assert_equal expected_initiator_data, user.to_initiator_data
  end

  test "invalid when name is blank" do
    user = User.new

    assert_not user.valid?
    assert user.errors.added?(:name, :blank)
  end

  test "invalid when email is blank" do
    user = User.new

    assert_not user.valid?
    assert user.errors.added?(:email, :blank)
  end

  test "invalid when email is duplicated" do
    User.create!(@valid_attrs)
    duplicate = User.new(@valid_attrs)

    assert_not duplicate.valid?
  end

  test "raises error on invalid role" do
    assert_raises ArgumentError do
      User.new(name: "X", email: "x@hireminator-domain.com", role: "hacker")
    end
  end

  test "encrypts sensitive fields" do
    user = User.create!(@valid_attrs)

    assert_equal Set.new(%i(name email)), user.encrypted_attributes
  end
end
