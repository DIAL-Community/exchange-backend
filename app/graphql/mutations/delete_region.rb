# frozen_string_literal: true

module Mutations
  class DeleteRegion < Mutations::BaseMutation
    argument :id, ID, required: true

    field :region, Types::RegionType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          region: nil,
          errors: ['Must be admin to delete a region.']
        }
      end

      region = Region.find_by(id:)
      if region.nil?
        return {
          region: nil,
          errors: ['Unable to uniquely identify region to delete.']
        }
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(region)
        region.destroy!
        successful_operation = true
      end

      if successful_operation
        # Successful deletion, return the deleted region with no errors
        {
          region:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client.
        {
          region: nil,
          errors: region.errors.full_messages
        }
      end
    end
  end
end
