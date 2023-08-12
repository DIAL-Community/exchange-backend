# frozen_string_literal: true

module Types
  class OfficeType < Types::BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :latitude, String, null: false
    field :longitude, String, null: false
    field :city, String, null: false
    field :organization_id, Integer, null: false
    field :country, Types::CountryType, null: false, method: :office_country
    field :region, String, null: false, method: :office_region
  end
end
