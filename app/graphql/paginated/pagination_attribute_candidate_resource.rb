# frozen_string_literal: true

module Paginated
  class PaginationAttributeCandidateResource < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      if !unsecure_read_allowed && context[:current_user].nil?
        return { total_count: 0 }
      end

      return { total_count: 0 } unless an_admin

      candidate_resources = CandidateResource.order(:name)
      unless search.blank?
        name_filter = candidate_resources.name_contains(search)
        description_filter = candidate_resources.where('LOWER(description) like LOWER(?)', "%#{search}%")
        candidate_resources = candidate_resources.where(id: (name_filter + description_filter).uniq)
      end

      { total_count: candidate_resources.count }
    end
  end
end