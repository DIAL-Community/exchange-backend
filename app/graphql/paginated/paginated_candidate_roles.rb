# frozen_string_literal: true

module Paginated
  class PaginatedCandidateRoles < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::CandidateRoleType], null: false

    def resolve(search:, offset_attributes:)
      return [] unless an_admin

      candidate_products = CandidateRole.order(rejected: :desc)
                                        .order(created_at: :desc)
                                        .order(:email)
      unless search.blank?
        email_filter = candidate_products.email_contains(search)
        description_filter = candidate_products.where('LOWER(description) like LOWER(?)', "%#{search}%")
        candidate_products = candidate_products.where(id: (email_filter + description_filter).uniq)
      end

      offset_params = offset_attributes.to_h
      candidate_products.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
