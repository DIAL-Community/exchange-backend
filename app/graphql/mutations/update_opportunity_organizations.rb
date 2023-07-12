# frozen_string_literal: true

module Mutations
  class UpdateOpportunityOrganizations < Mutations::BaseMutation
    argument :organization_slugs, [String], required: true
    argument :slug, String, required: true

    field :opportunity, Types::OpportunityType, null: true
    field :errors, [String], null: true

    def resolve(organization_slugs:, slug:)
      opportunity = Opportunity.find_by(slug:)

      unless an_admin
        return {
          opportunity: nil,
          errors: ['Must have proper rights to update an opportunity']
        }
      end

      opportunity.organizations = []
      if !organization_slugs.nil? && !organization_slugs.empty?
        organization_slugs.each do |organization_slug|
          current_organization = Organization.find_by(slug: organization_slug)
          opportunity.organizations << current_organization unless current_organization.nil?
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
