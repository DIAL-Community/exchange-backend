# frozen_string_literal: true

module Paginated
  class PaginationAttributeCandidateStatus < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      # Validate access to the current entity type.
      validate_access_to_resource(CandidateStatus.new)

      candidate_statuses = CandidateStatus.order(:name)
      unless search.blank?
        candidate_statuses = candidate_statuses.name_contains(search)
      end

      { total_count: candidate_statuses.count }
    end
  end
end
