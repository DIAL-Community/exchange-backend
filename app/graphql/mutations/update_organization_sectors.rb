# frozen_string_literal: true

module Mutations
  class UpdateOrganizationSectors < Mutations::BaseMutation
    argument :sector_slugs, [String], required: true
    argument :slug, String, required: true

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(sector_slugs:, slug:)
      organization = Organization.find_by(slug:)
      organization_policy = Pundit.policy(context[:current_user], organization || Organization.new)
      if organization.nil? || !organization_policy.edit_allowed?
        return {
          organization: nil,
          errors: ['Editing organization is not allowed.']
        }
      end

      organization.sectors = []
      if !sector_slugs.nil? && !sector_slugs.empty?
        sector_slugs.each do |sector_slug|
          current_sector = Sector.where(slug: sector_slug, is_displayable: true)
          unless current_sector.nil?
            organization.sectors << current_sector
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
