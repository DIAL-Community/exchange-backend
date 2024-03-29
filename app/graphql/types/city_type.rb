# frozen_string_literal: true

module Types
  class CityType < Types::BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :latitude, String, null: false
    field :longitude, String, null: false
    field :province, Types::ProvinceType, null: true
    field :organizations, [Types::OrganizationType], null: false

    def province
      Province.find_by(id: object.province_id)
    end

    def organizations
      organization_ids = Office.where(city: object.name).select('organization_id')
      Organization.where(id: organization_ids)
    end
  end
end
