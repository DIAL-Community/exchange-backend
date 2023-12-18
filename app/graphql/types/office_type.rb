# frozen_string_literal: true

module Types
  class OfficeType < Types::BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :city, String, null: false

    field :latitude, String, null: false
    field :longitude, String, null: false

    field :organization, Types::OrganizationType, null: false
    field :province, Types::ProvinceType, null: false
    field :country, Types::CountryType, null: false

    field :city_data, Types::CityType, null: true
    def city_data
      City.find_by(name: object.city)
    end
  end
end
