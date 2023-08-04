# frozen_string_literal: true

module Paginated
  class PaginationAttributeCandidateOrganization < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      candidate_organizations = CandidateOrganization.order(:name)
      unless search.blank?
        name_filter = candidate_organizations.name_contains(search)
        desc_filter = candidate_organizations\
                      .left_joins(:candidate_organization_descriptions)
                      .where('LOWER(candidate_organization_descriptions.description) like LOWER(?)', "%#{search}%")
        candidate_organizations = candidate_organizations.where(id: (name_filter + desc_filter).uniq)
      end

      { total_count: candidate_organizations.count }
    end
  end
end
