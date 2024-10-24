# frozen_string_literal: true

module Queries
  class OpportunityQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::OpportunityType, null: true

    def resolve(slug:)
      opportunity = Opportunity.find_by(slug:) if valid_slug?(slug)
      validate_access_to_resource(opportunity || Opportunity.new)
      opportunity
    end
  end

  class OpportunitiesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::OpportunityType], null: false

    def resolve(search:)
      validate_access_to_resource(Opportunity.new)
      opportunities = Opportunity.order(:name)
      opportunities = opportunities.name_contains(search) unless search.blank?
      opportunities
    end
  end
end
