# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class UpdateOpportunityCountries < Mutations::BaseMutation
    include Modules::Slugger

    argument :country_slugs, [String], required: true
    argument :slug, String, required: true

    field :opportunity, Types::OpportunityType, null: true
    field :errors, [String], null: true

    def resolve(country_slugs:, slug:)
      opportunity = Opportunity.find_by(slug: slug)

      unless an_admin || an_org_owner(opportunity.id)
        return {
          opportunity: nil,
          errors: ['Must have proper rights to update an opportunity']
        }
      end

      opportunity.countries = []
      if !country_slugs.nil? && !country_slugs.empty?
        country_slugs.each do |country_slug|
          current_country = Country.find_by(slug: country_slug)
          opportunity.countries << current_country
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
