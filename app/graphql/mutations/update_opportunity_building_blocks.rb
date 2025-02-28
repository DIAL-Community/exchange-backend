# frozen_string_literal: true

module Mutations
  class UpdateOpportunityBuildingBlocks < Mutations::BaseMutation
    argument :building_block_slugs, [String], required: true
    argument :slug, String, required: true

    field :opportunity, Types::OpportunityType, null: true
    field :errors, [String], null: true

    def resolve(building_block_slugs:, slug:)
      opportunity = Opportunity.find_by(slug:)
      opportunity_policy = Pundit.policy(context[:current_user], opportunity || Opportunity.new)
      if opportunity.nil? || !opportunity_policy.edit_allowed?
        return {
          opportunity: nil,
          errors: ['Editing opportunity is not allowed.']
        }
      end

      opportunity.building_blocks = []
      if !building_block_slugs.nil? && !building_block_slugs.empty?
        building_block_slugs.each do |building_block_slug|
          current_building_block = BuildingBlock.find_by(slug: building_block_slug)
          opportunity.building_blocks << current_building_block unless current_building_block.nil?
        end
      end

      if opportunity.save
        # Successful creation, return the created object with no errors
        {
          opportunity:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          opportunity: nil,
          errors: opportunity.errors.full_messages
        }
      end
    end
  end
end
