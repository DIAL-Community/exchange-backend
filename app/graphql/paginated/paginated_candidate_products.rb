# frozen_string_literal: true

module Paginated
  class PaginatedCandidateProducts < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::CandidateProductType], null: false

    def resolve(search:, offset_attributes:)
      candidate_products = CandidateProduct.order(:name)
      unless search.blank?
        name_filter = candidate_products.name_contains(search)
        desc_filter = candidate_products
                      .left_joins(:candidate_product_descriptions)
                      .where('LOWER(candidate_product_descriptions.description) like LOWER(?)', "%#{search}%")
        candidate_products = candidate_products.where(id: (name_filter + desc_filter).uniq)
      end

      offset_params = offset_attributes.to_h
      candidate_products.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
