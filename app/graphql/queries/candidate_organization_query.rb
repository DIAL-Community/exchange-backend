# frozen_string_literal: true

module Queries
  class CandidateOrganizationQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CandidateOrganizationType, null: true

    def resolve(slug:)
      validate_access_to_resource(CandidateOrganization.new)
      candidate_organization = CandidateOrganization.find_by(slug:) unless slug.blank?
      candidate_organization
    end
  end

  class CandidateOrganizationsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CandidateOrganizationType], null: false

    def resolve(search:)
      validate_access_to_resource(CandidateOrganization.new)
      candidate_organizations = CandidateOrganization.order(:name)
      candidate_organizations = candidate_organizations.name_contains(search) unless search.blank?
      candidate_organizations
    end
  end
end
