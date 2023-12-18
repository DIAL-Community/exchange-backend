# frozen_string_literal: true

module Types
  class RegionType < Types::BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :description, String, null: false
    field :aliases, GraphQL::Types::JSON, null: true

    field :countries, [Types::CountryType], null: true
  end
end
