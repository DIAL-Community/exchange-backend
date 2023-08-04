# frozen_string_literal: true

module Paginated
  class PaginationAttributeCandidateProduct < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      candidate_products = CandidateProduct.order(:name)
      unless search.blank?
        name_filter = candidate_products.name_contains(search)
        desc_filter = candidate_products
                      .left_joins(:candidate_product_descriptions)
                      .where('LOWER(candidate_product_descriptions.description) like LOWER(?)', "%#{search}%")
        candidate_products = candidate_products.where(id: (name_filter + desc_filter).uniq)
      end

      { total_count: candidate_products.count }
    end
  end
end
