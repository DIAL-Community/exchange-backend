# frozen_string_literal: true

module Mutations
  class UpdateOrganizationBuildingBlocks < Mutations::BaseMutation
    argument :building_block_slugs, [String], required: true
    argument :slug, String, required: true

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(building_block_slugs: [], slug:)
      organization = Organization.find_by(slug:)

      unless an_admin || an_org_owner(organization.id)
        return {
          organization: nil,
          errors: ['Must be admin or organization owner to update an organization']
        }
      end

      organization.building_blocks = []
      if !building_block_slugs.nil? && !building_block_slugs.empty?
        building_block_slugs.each do |building_block_slug|
          building_block = BuildingBlock.find_by(slug: building_block_slug)
          organization.building_blocks << building_block.id unless building_block.nil?
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
