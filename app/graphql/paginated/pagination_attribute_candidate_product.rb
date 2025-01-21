# frozen_string_literal: true

module Paginated
  class PaginationAttributeCandidateProduct < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      candidate_products = CandidateProduct.order(:name)
      unless search.blank?
        name_filter = candidate_products.name_contains(search)
        description_filter = candidate_products.where('LOWER(description) like LOWER(?)', "%#{search}%")
        candidate_products = candidate_products.where(id: (name_filter + description_filter).uniq)
      end

      is_admin = context[:current_user].roles.include?(User.user_roles[:admin])
      is_candidate_editor = context[:current_user].roles.include?(User.user_roles[:candidate_editor])
      unless is_admin || is_candidate_editor
        candidate_products = candidate_products.where(created_by_id: context[:current_user].id)
      end

      { total_count: candidate_products.count }
    end
  end
end
