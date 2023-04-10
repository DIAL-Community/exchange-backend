# frozen_string_literal: true

module Mutations
  class UpdateOpportunitySectors < Mutations::BaseMutation
    argument :sector_slugs, [String], required: true
    argument :slug, String, required: true

    field :opportunity, Types::OpportunityType, null: true
    field :errors, [String], null: true

    def resolve(sector_slugs:, slug:)
      opportunity = Opportunity.find_by(slug: slug)

      unless an_admin || an_org_owner(opportunity.id)
        return {
          opportunity: nil,
          errors: ['Must have proper rights to update an opportunity']
        }
      end

      opportunity.sectors = []
      if !sector_slugs.nil? && !sector_slugs.empty?
        sector_slugs.each do |sector_slug|
          current_sector = Sector.where(slug: sector_slug, is_displayable: true)
          unless current_sector.nil?
            opportunity.sectors << current_sector
          end
        end
      end

      if opportunity.save
        # Successful creation, return the created object with no errors
        {
          opportunity: opportunity,
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
