# frozen_string_literal: true

module Paginated
  class PaginatedCandidateStatuses < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::CandidateStatusType], null: false

    def resolve(search:, offset_attributes:)
      # Validate access to the current entity type.
      validate_access_to_resource(CandidateStatus.new)

      candidate_statuses = CandidateStatus.order(:name)
      unless search.blank?
        candidate_statuses = candidate_statuses.name_contains(search)
      end

      offset_params = offset_attributes.to_h
      candidate_statuses.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
