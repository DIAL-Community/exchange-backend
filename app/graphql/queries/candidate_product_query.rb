# frozen_string_literal: true

module Queries
  class CandidateProductQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CandidateProductType, null: true

    def resolve(slug:)
      candidate_product = CandidateProduct.find_by(slug:) if valid_slug?(slug)
      validate_access_to_instance(candidate_product || CandidateProduct.new)
      candidate_product
    end
  end

  class CandidateProductsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CandidateProductType], null: false

    def resolve(search:)
      validate_access_to_resource(CandidateProduct.new)
      candidate_products = CandidateProduct.order(:name)
      candidate_products = candidate_products.name_contains(search) unless search.blank?
      candidate_products
    end
  end
end
