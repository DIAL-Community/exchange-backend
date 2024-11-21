# frozen_string_literal: true

module Mutations
  class DeleteOrganization < Mutations::BaseMutation
    argument :id, ID, required: true

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      organization = Organization.find_by(id:)
      organization_policy = Pundit.policy(context[:current_user], organization || Organization.new)
      if organization.nil? || !organization_policy.delete_allowed?
        return {
          organization: nil,
          errors: ['Deleting organization is not allowed.']
        }
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        organization_owners = User.where(organization_id: id)
        organization_owners.each do |organization_owner|
          organization_owner.organization_id = nil
          if organization_owner.save!
            puts "Unassigning organization owner: '#{organization_owner.email}'."
          end
        end

        assign_auditable_user(organization)
        organization.destroy!

        successful_operation = true
      end

      if successful_operation
        # Successful deletion, return the deleted organization with no errors
        {
          organization:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          organization: nil,
          errors: organization.errors.full_messages
        }
      end
    end
  end
end
