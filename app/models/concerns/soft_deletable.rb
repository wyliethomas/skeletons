# frozen_string_literal: true

# SoftDeletable concern for models that need soft delete functionality
#
# Provides soft delete functionality where records are marked as deleted
# rather than permanently removed from the database. This preserves data
# for audit trails, compliance, and data recovery.
#
# Requirements:
# - Model must have a `deleted_at` datetime column
#
# Usage:
#   class Client < ApplicationRecord
#     include SoftDeletable
#   end
#
#   client.soft_delete!           # Mark as deleted
#   client.restore!               # Restore deleted record
#   Client.with_deleted           # Include deleted records
#   Client.only_deleted           # Only deleted records
#   client.deleted?               # Check if deleted
module SoftDeletable
  extend ActiveSupport::Concern

  included do
    # Default scope to exclude soft-deleted records
    default_scope { where(deleted_at: nil) }

    # Scopes for querying deleted records
    scope :with_deleted, -> { unscope(where: :deleted_at) }
    scope :only_deleted, -> { unscope(where: :deleted_at).where.not(deleted_at: nil) }
  end

  ##
  # Soft delete this record
  #
  # @param deleted_by [User, nil] User who performed the deletion
  # @return [Boolean] true if successful
  def soft_delete!(deleted_by: nil)
    update_columns(
      deleted_at: Time.current,
      deleted_by_id: deleted_by&.id
    )

    Rails.logger.info("Soft deleted #{self.class.name} ##{id} by user ##{deleted_by&.id}")
    true
  end

  ##
  # Restore a soft-deleted record
  #
  # @return [Boolean] true if successful
  def restore!
    update_columns(
      deleted_at: nil,
      deleted_by_id: nil
    )

    Rails.logger.info("Restored #{self.class.name} ##{id}")
    true
  end

  ##
  # Check if record is soft-deleted
  #
  # @return [Boolean] true if deleted
  def deleted?
    deleted_at.present?
  end

  ##
  # Override destroy to perform soft delete instead
  #
  # @return [Boolean] true if successful
  def destroy
    soft_delete!
  end

  ##
  # Permanently delete the record (use with caution!)
  #
  # @return [Boolean] true if successful
  def destroy!
    self.class.unscoped.find(id).delete
  end

  class_methods do
    ##
    # Restore all soft-deleted records
    #
    # @return [Integer] number of records restored
    def restore_all
      only_deleted.update_all(deleted_at: nil, deleted_by_id: nil)
    end

    ##
    # Permanently delete all soft-deleted records older than a certain date
    # Use for GDPR compliance or data retention policies
    #
    # @param older_than [ActiveSupport::Duration] Time period (e.g., 90.days)
    # @return [Integer] number of records permanently deleted
    def purge_deleted(older_than: 90.days)
      cutoff_date = older_than.ago
      records = only_deleted.where('deleted_at < ?', cutoff_date)
      count = records.count

      records.each(&:destroy!)

      Rails.logger.info("Permanently deleted #{count} #{name} records older than #{cutoff_date}")
      count
    end
  end
end
