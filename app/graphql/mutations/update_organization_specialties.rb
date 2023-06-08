# frozen_string_literal: true

module Mutations
  class UpdateOrganizationSpecialties < Mutations::BaseMutation
    argument :specialties, [String], required: true
    argument :slug, String, required: true

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def valid_specialty(specialty)
      [
        'UX & Design',
        'Big Data',
        'AI / Machine Learning',
        'SaaS / Hosting Services',
        'Mobile Apps'
      ].include?(specialty)
    end

    def resolve(specialties: [], slug:)
      organization = Organization.find_by(slug:)

      unless an_admin || an_org_owner(organization.id)
        return {
          organization: nil,
          errors: ['Must be admin or organization owner to update an organization']
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
