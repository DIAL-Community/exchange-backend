# frozen_string_literal: true

module Paginated
  class PaginatedCandidateResources < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :countries, [String], required: false, default_value: []
    argument :in_review_only, Boolean, required: false, default_value: false

    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::CandidateResourceType], null: false

    def resolve(search:, countries:, in_review_only:, offset_attributes:)
      validate_access_to_resource(CandidateResource.new)
      candidate_resources = CandidateResource.order(rejected: :desc)
                                             .order(created_at: :desc)
                                             .order(:name)
      unless search.blank?
        name_filter = candidate_resources.name_contains(search)
        description_filter = candidate_resources.where('LOWER(description) like LOWER(?)', "%#{search}%")
        candidate_resources = candidate_resources.where(id: (name_filter + description_filter).uniq)
      end

      filtered_countries = countries.reject { |x| x.nil? || x.empty? }
      unless filtered_countries.empty?
        candidate_resources = candidate_resources.left_outer_joins(:countries)
                                                 .where(countries: { id: filtered_countries })
      end

      if in_review_only
        candidate_resources = candidate_resources.where(rejected: nil)
      end

      offset_params = offset_attributes.to_h
      candidate_resources.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
