# frozen_string_literal: true

module Paginated
  class PaginatedCandidateOrganizations < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::CandidateOrganizationType], null: false

    def resolve(search:, offset_attributes:)
      # Validate access to the current entity type.
      validate_access_to_resource(CandidateOrganization.new)

      candidate_organizations = CandidateOrganization.order(rejected: :desc)
                                                     .order(created_at: :desc)
                                                     .order(:name)
      unless search.blank?
        name_filter = candidate_organizations.name_contains(search)
        description_filter = candidate_organizations.where('LOWER(description) like LOWER(?)', "%#{search}%")
        candidate_organizations = candidate_organizations.where(id: (name_filter + description_filter).uniq)
      end

      offset_params = offset_attributes.to_h
      candidate_organizations.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
