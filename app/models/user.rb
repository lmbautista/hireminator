# frozen_string_literal: true

class User < ApplicationRecord
  encrypts :name
  encrypts :email, deterministic: true

  ROLES = [
    ROLE_CANDIDATE = "candidate",
    ROLE_RECRUITER = "recruiter",
    ROLE_SUPPORT = "support",
    ROLE_SYSTEM = "system"
  ].freeze

  enum(:role, ROLES.index_with { _1 })

  has_many :sessions, dependent: :destroy
  has_many :conversations, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: ROLES }
end
