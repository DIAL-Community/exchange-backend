# frozen_string_literal: true

module Mutations
  class DeleteResource < Mutations::BaseMutation
    argument :id, ID, required: true

    field :resource, Types::ResourceType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      resource = Resource.find_by(id:)
      resource_policy = Pundit.policy(context[:current_user], resource || Resource.new)
      if resource.nil? || !resource_policy.delete_allowed?
        return {
          resource: nil,
          errors: ['Deleting resource is not allowed.']
        }
      end

      assign_auditable_user(resource)
      if resource.destroy
        # Successful deletion, return the deleted resource with no errors
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
