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

  class SearchResourcesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :show_in_exchange, Boolean, required: false, default_value: false
    argument :show_in_wizard, Boolean, required: false, default_value: false

    type Types::ResourceType.connection_type, null: false

    def resolve(search:, show_in_exchange:, show_in_wizard:)
      resources = Resource.order(:name)
      resources = resources.name_contains(search) unless search.blank?

      resources = resources.where(show_in_exchange: true) if show_in_exchange
      resources = resources.where(show_in_wizard: true) if show_in_wizard

      resources
    end
  end
end
