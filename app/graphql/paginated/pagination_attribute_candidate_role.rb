# frozen_string_literal: true

module Paginated
  class PaginationAttributeCandidateRole < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      # Validate access to the current entity type.
      validate_access_to_resource(CandidateRole.new)

      candidate_roles = CandidateRole.order(:name)
      unless search.blank?
        name_filter = candidate_roles.email_contains(search)
        description_filter = candidate_roles.where('LOWER(description) like LOWER(?)', "%#{search}%")
        candidate_roles = candidate_roles.where(id: (name_filter + description_filter).uniq)
      end

      { total_count: candidate_roles.count }
    end
  end
end
