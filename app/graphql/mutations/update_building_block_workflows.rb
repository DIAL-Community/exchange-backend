# frozen_string_literal: true

module Mutations
  class UpdateBuildingBlockWorkflows < Mutations::BaseMutation
    argument :workflow_slugs, [String], required: true
    argument :slug, String, required: true

    field :building_block, Types::BuildingBlockType, null: true
    field :errors, [String], null: true

    def resolve(workflow_slugs:, slug:)
      building_block = BuildingBlock.find_by(slug:) unless slug.blank?
      building_block_policy = Pundit.policy(context[:current_user], building_block || BuildingBlock.new)
      unless building_block_policy.edit_allowed?
        return {
          building_block: nil,
          errors: ['Editing building block is not allowed.']
        }
      end

      building_block.workflows = []
      if !workflow_slugs.nil? && !workflow_slugs.empty?
        workflow_slugs.each do |workflow_slug|
          current_workflow = Workflow.find_by(slug: workflow_slug)
          building_block.workflows << current_workflow unless current_workflow.nil?
        end
      end

      if building_block.save
        # Successful creation, return the created object with no errors
        {
          building_block:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          building_block: nil,
          errors: building_block.errors.full_messages
        }
      end
    end
  end
end
