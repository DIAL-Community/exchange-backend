# frozen_string_literal: true

module Queries
  class OpportunitiesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::OpportunityType], null: false

    def resolve(search:)
      opportunities = Opportunity.order(:name)
      opportunities = opportunities.name_contains(search) unless search.blank?
      opportunities
    end
  end

  class OpportunityQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::OpportunityType, null: true

    def resolve(slug:)
      Opportunity.find_by(slug:)
    end
  end
end
