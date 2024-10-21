# frozen_string_literal: true

module Queries
  class SectorQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::SectorType, null: true

    def resolve(slug:)
      Sector.find_by(slug:)
    end
  end

  class SectorsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :locale, String, required: false, default_value: 'en'
    type [Types::SectorType], null: false

    def resolve(search:, locale:)
      sectors = Sector.where(is_displayable: true, locale:).order(:name)
      sectors = sectors.name_contains(search) unless search.blank?
      sectors
    end
  end
end
