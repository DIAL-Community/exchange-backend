# frozen_string_literal: true

module Types
  class CountryType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :code, String, null: false
    field :code_longer, String, null: false
    field :latitude, String, null: false
    field :longitude, String, null: false
    field :aliases, [String], null: false

    field :organizations, [Types::OrganizationType], null: true
    field :projects, [Types::ProjectType], null: true
    field :regions, [Types::RegionType], null: true

    field :products, [Types::ProductType], null: true
    field :dpi_products, [Types::ProductType], null: true
    def dpi_products
      dpi_building_block = BuildingBlock.category_types[:DPI]
      dpi_building_blocks = BuildingBlock.where(category: dpi_building_block)

      object.products.joins(:building_blocks).where(id: dpi_building_blocks.ids)
    end

    field :resources, [Types::ResourceType], null: true
  end
end
