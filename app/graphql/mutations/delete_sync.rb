# frozen_string_literal: true

module Mutations
  class DeleteSync < Mutations::BaseMutation
    argument :id, ID, required: true

    field :sync, Types::SyncType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          sync: nil,
          errors: ['Must be admin to delete a sync.']
        }
      end

      sync = TenantSync.find_by(id:)
      if sync.nil?
        return {
          sync: nil,
          errors: ['Unable to uniquely identify sync to delete.']
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
