# frozen_string_literal: true

module Queries
  class OriginQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::OriginType, null: false

    def resolve(slug:)
      origin = Origin.find_by(slug:) if valid_slug?(slug)
      validate_access_to_instance(origin || Origin.new)
      origin
    end
  end

  class OriginsQuery < Queries::BaseQuery
    argument :search, String, required: true
    type [Types::OriginType], null: false

    def resolve(search:)
      origins = Origin.order(:name)
      origins = origins.name_contains(search) unless search.blank?
      origins
    end
  end
end
