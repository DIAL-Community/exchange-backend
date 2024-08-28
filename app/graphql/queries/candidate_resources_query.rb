# frozen_string_literal: true

module Queries
  class CandidateResourcesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CandidateResourceType], null: false

    def resolve(search:)
      candidate_resources = CandidateResource.order(:name)
      candidate_resources = candidate_resources.name_contains(search) unless search.blank?
      candidate_resources
    end
  end

  class CandidateResourceQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CandidateResourceType, null: true

    def resolve(slug:)
      CandidateResource.find_by(slug:)
    end
  end
end
