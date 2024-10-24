# frozen_string_literal: true

module Queries
  class ResourceQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::ResourceType, null: true

    def resolve(slug:)
      resource = Resource.find_by(slug:) if valid_slug?(slug)
      validate_access_to_resource(resource || Resource.new)
      resource
    end
  end

  class ResourcesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::ResourceType], null: false

    def resolve(search:)
      validate_access_to_resource(Resource.new)
      resources = Resource.order(:name)
      resources = resources.name_contains(search) unless search.blank?
      resources
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
