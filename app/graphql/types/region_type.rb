# frozen_string_literal: true

module Types
  class RegionType < Types::BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :latitude, String, null: false
    field :longitude, String, null: false

    field :country, Types::CountryType, null: false
  end
end
