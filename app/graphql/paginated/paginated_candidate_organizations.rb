# frozen_string_literal: true

module Paginated
  class PaginatedCandidateOrganizations < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::CandidateOrganizationType], null: false

    def resolve(search:, offset_attributes:)
      return [] unless an_admin

      candidate_organizations = CandidateOrganization.order(:name)
      unless search.blank?
        name_filter = candidate_organizations.name_contains(search)
        desc_filter = candidate_organizations
                      .left_joins(:candidate_organization_descriptions)
                      .where('LOWER(candidate_organization_descriptions.description) like LOWER(?)', "%#{search}%")
        candidate_organizations = candidate_organizations.where(id: (name_filter + desc_filter).uniq)
      end

      offset_params = offset_attributes.to_h
      candidate_organizations.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
