# frozen_string_literal: true

module Types
  class SectorType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false

    field :origin_id, Integer, null: true
    field :origin, Types::OriginType, null: false
    def origin
      Origin.find(object.origin_id)
    end

    field :datasets, [Types::DatasetType], null: false
    field :products, [Types::ProductType], null: false
    field :projects, [Types::ProjectType], null: false
    field :organizations, [Types::OrganizationType], null: false

    def datasets
      Dataset.joins(:sectors)
             .where(sectors: { slug: object.slug, locale: I18n.locale })
    end

    def products
      Product.joins(:sectors)
             .where(sectors: { slug: object.slug, locale: I18n.locale })
    end

    def projects
      Project.joins(:sectors)
             .where(sectors: { slug: object.slug, locale: I18n.locale })
    end

    def organizations
      Organization.joins(:sectors)
                  .where(sectors: { slug: object.slug, locale: I18n.locale })
    end

    field :is_displayable, Boolean, null: true
    field :locale, String, null: true

    field :parent_sector_id, ID, null: true
    field :sub_sectors, [Types::SectorType], null: true
  end
end
