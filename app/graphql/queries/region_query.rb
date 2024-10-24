# frozen_string_literal: true

module Queries
  class RegionQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::RegionType, null: true

    def resolve(slug:)
      region = Region.find_by(slug:) if valid_slug?(slug)
      validate_access_to_resource(region || Region.new)
      region
    end
  end

  class RegionsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::RegionType], null: false

    def resolve(search:)
      validate_access_to_resource(Region.new)
      regions = Region.order(:name)
      regions = regions.name_contains(search) unless search.blank?
      regions
    end
  end
end
