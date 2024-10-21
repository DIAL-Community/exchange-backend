# frozen_string_literal: true

module Paginated
  class PaginatedCandidateRoles < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::CandidateRoleType], null: false

    def resolve(search:, offset_attributes:)
      if !unsecured_read_allowed && context[:current_user].nil?
        return []
      end

      return [] unless an_admin

      candidate_roles = CandidateRole.order(rejected: :desc)
                                     .order(created_at: :desc)
                                     .order(:email)
      unless search.blank?
        email_filter = candidate_roles.email_contains(search)
        description_filter = candidate_roles.where('LOWER(description) like LOWER(?)', "%#{search}%")
        candidate_roles = candidate_roles.where(id: (email_filter + description_filter).uniq)
      end

      offset_params = offset_attributes.to_h
      candidate_roles.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
