# frozen_string_literal: true

module Mutations
  class DeleteSector < Mutations::BaseMutation
    argument :id, ID, required: true

    field :sector, Types::SectorType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          sector: nil,
          errors: ['Must be admin to delete a sector.']
        }
      end

      sector = Sector.find_by(id:)
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
