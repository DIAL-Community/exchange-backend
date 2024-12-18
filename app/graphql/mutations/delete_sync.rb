# frozen_string_literal: true

module Mutations
  class DeleteSync < Mutations::BaseMutation
    argument :id, ID, required: true

    field :sync, Types::SyncType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      sync = TenantSyncConfiguration.find_by(id:)
      sync_policy = Pundit.policy(context[:current_user], sync || TenantSyncConfiguration.new)
      if sync.nil? || !sync_policy.delete_allowed?
        return {
          sync: nil,
          errors: ['Deleting sync is not allowed.']
        }
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(sync)
        sync.destroy
        successful_operation = true
      end

      if successful_operation
        # Successful deletion, return the deleted sync with no errors
        {
          sync:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client.
        {
          sync: nil,
          errors: sync.errors.full_messages
        }
      end
    end
  end
end
