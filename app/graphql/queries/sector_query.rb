# frozen_string_literal: true

module Queries
  class SectorQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::SectorType, null: true

    def resolve(slug:)
      sector = Sector.find_by(slug:) if valid_slug?(slug)
      validate_access_to_instance(sector || Sector.new)
      sector
    end
  end

  class SectorsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :locale, String, required: false, default_value: 'en'
    type [Types::SectorType], null: false

    def resolve(search:, locale:)
      validate_access_to_resource(Sector.new)
      sectors = Sector.where(is_displayable: true, locale:).order(:name)
      sectors = sectors.name_contains(search) unless search.blank?
      sectors
    end
  end
end
