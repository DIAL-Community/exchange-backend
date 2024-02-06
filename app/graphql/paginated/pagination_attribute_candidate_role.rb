# frozen_string_literal: true

module Paginated
  class PaginationAttributeCandidateRole < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      if !unsecure_read_allowed && context[:current_user].nil?
        return { total_count: 0 }
      end

      return { total_count: 0 } unless an_admin

      candidate_products = CandidateRole.order(:name)
      unless search.blank?
        name_filter = candidate_products.email_contains(search)
        description_filter = candidate_products.where('LOWER(description) like LOWER(?)', "%#{search}%")
        candidate_products = candidate_products.where(id: (name_filter + description_filter).uniq)
      end

      { total_count: candidate_products.count }
    end
  end
end
