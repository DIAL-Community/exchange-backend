# frozen_string_literal: true

module Paginated
  class PaginationAttributeCandidateStatus < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      if !unsecured_read_allowed && context[:current_user].nil?
        return { total_count: 0 }
      end

      return { total_count: 0 } unless an_admin

      candidate_statuses = CandidateStatus.order(:name)
      unless search.blank?
        candidate_statuses = candidate_statuses.name_contains(search)
      end

      { total_count: candidate_statuses.count }
    end
  end
end
