# frozen_string_literal: true

module Mutations
  class UpdateOrganizationSpecialties < Mutations::BaseMutation
    argument :specialties, [String], required: true
    argument :slug, String, required: true

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def valid_specialty(specialty)
      [
        'AI / Machine Learning',
        'Data Analytics & Visualization',
        'Mobile Apps',
        'SaaS / Hosting Services',
        'UX & Design',
        'Web Development'
      ].include?(specialty)
    end

    def resolve(specialties: [], slug:)
      organization = Organization.find_by(slug:)
      organization_policy = Pundit.policy(context[:current_user], organization || Organization.new)
      if organization.nil? || !organization_policy.edit_allowed?
        return {
          organization: nil,
          errors: ['Editing organization is not allowed.']
        }
      end

      organization.specialties = []
      if !specialties.nil? && !specialties.empty?
        specialties.each do |specialty|
          organization.specialties << specialty if valid_specialty(specialty)
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
