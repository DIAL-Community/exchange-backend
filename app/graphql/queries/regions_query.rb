# frozen_string_literal: true

module Queries
  class RegionsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::RegionType], null: false

    def resolve(search:)
      regions = Region.order(:name)
      regions = regions.name_contains(search) unless search.blank?
      regions
    end
  end

  class RegionQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::RegionType, null: true

    def resolve(slug:)
      Region.find_by(slug:)
    end
  end
end
