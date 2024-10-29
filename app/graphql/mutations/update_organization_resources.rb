# frozen_string_literal: true

module Mutations
  class UpdateOrganizationResources < Mutations::BaseMutation
    argument :resource_slugs, [String], required: true
    argument :slug, String, required: true

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(resource_slugs: [], slug:)
      organization = Organization.find_by(slug:)
      organization_policy = Pundit.policy(context[:current_user], organization || Organization.new)
      if organization.nil? || !organization_policy.edit_allowed?
        return {
          organization: nil,
          errors: ['Editing organization is not allowed.']
        }
      end

      organization.resources = []
      if !resource_slugs.nil? && !resource_slugs.empty?
        resource_slugs.each do |resource_slug|
          resource = Resource.find_by(slug: resource_slug)
          organization.resources << resource unless resource.nil?
        end
      end

      if organization.save
        # Successful creation, return the created object with no errors
        {
          organization:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          organization: nil,
          errors: organization.errors.full_messages
        }
      end
    end
  end
end
