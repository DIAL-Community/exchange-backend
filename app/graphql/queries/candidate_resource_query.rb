# frozen_string_literal: true

module Queries

  class CandidateResourceQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CandidateResourceType, null: true

    def resolve(slug:)
      validate_access_to_resource(CandidateResource.new)
      candidate_resource = CandidateResource.find_by(slug:) unless slug.blank?
      candidate_resource
    end
  end

  class CandidateResourcesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CandidateResourceType], null: false

    def resolve(search:)
      validate_access_to_resource(CandidateResource.new)
      candidate_resources = CandidateResource.order(:name)
      candidate_resources = candidate_resources.name_contains(search) unless search.blank?
      candidate_resources
    end
  end
end
