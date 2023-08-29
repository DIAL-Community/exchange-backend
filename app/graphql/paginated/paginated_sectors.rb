# frozen_string_literal: true

module Paginated
  class PaginatedSectors < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::SectorType], null: false

    def resolve(search:, offset_attributes:)
      sectors = Sector.order(:name)
                      .where(locale: I18n.locale)
      unless search.blank?
        sectors = sectors.name_contains(search)
      end

      offset_params = offset_attributes.to_h
      sectors.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
