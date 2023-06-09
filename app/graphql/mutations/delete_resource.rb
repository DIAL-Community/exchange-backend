# frozen_string_literal: true

module Mutations
  class DeleteResource < Mutations::BaseMutation
    argument :id, ID, required: true

    field :resource, Types::ResourceType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          resource: nil,
          errors: ['Must be admin to delete a resource.']
        }
      end

      resource = Resource.find_by(id:)
      assign_auditable_user(resource)
      if resource.destroy
        # Successful deletion, return the nil resource with no errors
        {
          resource:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          resource: nil,
          errors: resource.errors.full_messages
        }
      end
    end
  end
end
