# frozen_string_literal: true

# Client Model
#
# Represents a tenant/organization in the multi-tenant system.
# Each client can have multiple users and owns all related data.
#
# Features:
# - URL-based identification using 12-char urlkey
# - Soft delete for data preservation
# - Multi-user support with role-based access
#
# Usage:
#   client = Client.create(name: "ACME Corp")
#   client.users.create(...)
class Client < ApplicationRecord
  include Urlkeyable
  include SoftDeletable

  has_many :users, dependent: :destroy

  validates :name, presence: true
end
