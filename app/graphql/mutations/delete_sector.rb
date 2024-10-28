# frozen_string_literal: true

module Mutations
  class DeleteSector < Mutations::BaseMutation
    argument :id, ID, required: true

    field :sector, Types::SectorType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      sector = Sector.find_by(id:)
      sector_policy = Pundit.policy(context[:current_user], sector || Sector.new)
      if sector.nil? || !sector_policy.delete_allowed?
        return {
          sector: nil,
          errors: ['Deleting sector is not allowed.']
        }
      end

      assign_auditable_user(sector)
      if sector.destroy
        # Successful deletion, return the deleted sector with no errors
        {
          sector:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          sector: nil,
          errors: sector.errors.full_messages
        }
      end
    end
  end
end
