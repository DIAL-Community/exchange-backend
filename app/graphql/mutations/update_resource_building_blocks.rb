# frozen_string_literal: true

module Mutations
  class UpdateResourceBuildingBlocks < Mutations::BaseMutation
    argument :building_block_slugs, [String], required: true
    argument :mapping_status, String, required: false
    argument :slug, String, required: true

    field :resource, Types::ResourceType, null: true
    field :errors, [String], null: true

    def resolve(building_block_slugs:, mapping_status:, slug:)
      resource = Resource.find_by(slug:)
      resource_policy = Pundit.policy(context[:current_user], resource || Resource.new)
      if resource.nil? || !resource_policy.edit_allowed?
        return {
          resource: nil,
          errors: ['Editing resource is not allowed.']
        }
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        resource.building_blocks = []
        if !building_block_slugs.nil? && !building_block_slugs.empty?
          building_block_slugs.each do |building_block_slug|
            current_building_block = BuildingBlock.find_by(slug: building_block_slug)
            next if current_building_block.nil?

            current_resource_building_block = ResourceBuildingBlock.find_by(
              resource:,
              building_block: current_building_block
            )
            current_resource_building_block = ResourceBuildingBlock.new if current_resource_building_block.nil?
            current_resource_building_block.resource = resource
            current_resource_building_block.building_block = current_building_block
            current_resource_building_block.mapping_status = mapping_status
            current_resource_building_block.save!
          end
        end
        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          resource:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          resource: nil,
          errors: resource.errors.full_messages
        }
      end
    end
  end
end
