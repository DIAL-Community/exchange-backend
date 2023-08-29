# frozen_string_literal: true

module Paginated
  class PaginationAttributeCandidateDataset < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      return { total_count: 0 } unless an_admin

      candidate_products = CandidateDataset.order(:name)
      unless search.blank?
        name_filter = candidate_products.name_contains(search)
        description_filter = candidate_products.where('LOWER(description) like LOWER(?)', "%#{search}%")
        candidate_products = candidate_products.where(id: (name_filter + description_filter).uniq)
      end

      { total_count: candidate_products.count }
    end
  end
end
