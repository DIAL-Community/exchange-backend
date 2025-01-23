# frozen_string_literal: true

module Paginated
  class PaginationAttributeCandidateProduct < Queries::BaseQuery
    argument :current_user_only, Boolean, required: false, default_value: false
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(current_user_only:, search:)
      validate_access_to_resource(CandidateProduct.new)
      candidate_products = CandidateProduct.order(:name)
      unless search.blank?
        name_filter = candidate_products.name_contains(search)
        description_filter = candidate_products.where('LOWER(description) like LOWER(?)', "%#{search}%")
        candidate_products = candidate_products.where(id: (name_filter + description_filter).uniq)
      end

      current_user = context[:current_user]
      is_admin = current_user.roles.include?(User.user_roles[:admin])
      is_candidate_editor = current_user.roles.include?(User.user_roles[:candidate_editor])
      if !is_admin && !is_candidate_editor || current_user_only
        candidate_products = candidate_products.where(created_by_id: current_user.id)
      end

      { total_count: candidate_products.count }
    end
  end
end
