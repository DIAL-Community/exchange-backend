# frozen_string_literal: true

module Paginated
  class PaginationAttributeCandidateResource < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :countries, [String], required: false, default_value: []
    argument :in_review_only, Boolean, required: false, default_value: false

    type Attributes::PaginationAttributes, null: false

    def resolve(search:, countries:, in_review_only:)
      validate_access_to_resource(CandidateResource.new)
      candidate_resources = CandidateResource.order(:name)
      unless search.blank?
        name_filter = candidate_resources.name_contains(search)
        description_filter = candidate_resources.where('LOWER(description) like LOWER(?)', "%#{search}%")
        candidate_resources = candidate_resources.where(id: (name_filter + description_filter).uniq)
      end

      if in_review_only
        candidate_resources = candidate_resources.where(rejected: nil)
      end

      filtered_countries = countries.reject { |x| x.nil? || x.empty? }
      unless filtered_countries.empty?
        candidate_resources = candidate_resources.left_outer_joins(:countries)
                                                 .where(countries: { id: filtered_countries })
      end

      { total_count: candidate_resources.count }
    end
  end
end
