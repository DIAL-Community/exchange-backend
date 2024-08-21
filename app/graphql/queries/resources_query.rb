# frozen_string_literal: true

module Queries
  class ResourcesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::ResourceType], null: false

    def resolve(search:)
      resources = Resource.order(:name)
      resources = resources.name_contains(search) unless search.blank?
      resources
    end
  end

  class ResourceQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::ResourceType, null: true

    def resolve(slug:)
      Resource.find_by(slug:)
    end
  end

  class ResourceTypesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::ResourceTypeType], null: false

    def resolve(search:)
      resource_types = ResourceType.all.order(:name)
      resource_types = resource_types.name_contains(search) unless search.blank?
      resource_types
    end
  end
end
