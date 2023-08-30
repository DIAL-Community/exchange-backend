# frozen_string_literal: true

module Paginated
  class PaginationAttributeStorefront < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :sectors, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []
    argument :building_blocks, [String], required: false, default_value: []
    argument :specialties, [String], required: false, default_value: []
    argument :certifications, [String], required: false, default_value: []

    type Attributes::PaginationAttributes, null: false

    def resolve(search:, sectors:, countries:, building_blocks:, specialties:, certifications:)
      organizations = Organization.order(:name).where(has_storefront: true)

      unless search.blank?
        name_orgs = organizations.name_contains(search)
        desc_orgs = organizations.joins(:organization_descriptions)
                                 .where('LOWER(description) like LOWER(?)', "%#{search}%")
        alias_orgs = organizations.where("LOWER(array_to_string(aliases,',')) like LOWER(?)", "%#{search}%")
        organizations = organizations.where(id: (name_orgs + desc_orgs + alias_orgs).uniq)
      end

      filtered_sectors = sectors.reject { |x| x.nil? || x.empty? }
      unless filtered_sectors.empty?
        organizations = organizations.joins(:sectors)
                                     .where(sectors: { id: filtered_sectors })
      end

      filtered_countries = countries.reject { |x| x.nil? || x.empty? }
      unless filtered_countries.empty?
        organizations = organizations.joins(:countries)
                                     .where(countries: { id: filtered_countries })
      end

      unless building_blocks.empty?
        organizations = organizations.where('building_blocks ?| ARRAY[:building_blocks]', building_blocks:)
      end

      unless certifications.empty?
        organizations = organizations.where('certifications ?| ARRAY[:certifications]', certifications:)
      end

      unless specialties.empty?
        organizations = organizations.where('specialties ?| ARRAY[:specialties]', specialties:)
      end

      { total_count: organizations.count }
    end
  end
end
