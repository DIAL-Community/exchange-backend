# frozen_string_literal: true

module Paginated
  class PaginatedRegions < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::RegionType], null: false

    def resolve(search:, offset_attributes:)
      regions = Region.order(:name)
      unless search.blank?
        regions = regions.name_contains(search)
      end

      offset_params = offset_attributes.to_h
      regions.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
