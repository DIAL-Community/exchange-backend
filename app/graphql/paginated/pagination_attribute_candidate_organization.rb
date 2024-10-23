# frozen_string_literal: true

module Paginated
  class PaginationAttributeCandidateOrganization < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      validate_access_to_resource(CandidateOrganization.new)
      candidate_organizations = CandidateOrganization.order(:name)
      unless search.blank?
        name_filter = candidate_organizations.name_contains(search)
        description_filter = candidate_organizations.where('LOWER(description) like LOWER(?)', "%#{search}%")
        candidate_organizations = candidate_organizations.where(id: (name_filter + description_filter).uniq)
      end

      { total_count: candidate_organizations.count }
    end
  end
end
