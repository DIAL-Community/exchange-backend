# frozen_string_literal: true

module Mutations
  class UpdateOrganizationProjects < Mutations::BaseMutation
    argument :project_slugs, [String], required: true
    argument :slug, String, required: true

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(project_slugs:, slug:)
      organization = Organization.find_by(slug:)
      organization_policy = Pundit.policy(context[:current_user], organization || Organization.new)
      if organization.nil? || !organization_policy.edit_allowed?
        return {
          organization: nil,
          errors: ['Editing organization is not allowed.']
        }
      end

      organization.projects = []
      if !project_slugs.nil? && !project_slugs.empty?
        project_slugs.each do |project_slug|
          current_project = Project.find_by(slug: project_slug)
          unless current_project.nil?
            organization.projects << current_project
          end
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
