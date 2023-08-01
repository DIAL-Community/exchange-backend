# frozen_string_literal: true

module Paginated
  class PaginationAttributeOrganization < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :sectors, [String], required: false, default_value: []

    type Attributes::PaginationAttributes, null: false

    def resolve(search:, sectors:)
      organizations = Organization.order(:name)
      unless search.blank?
        name_filter = organizations.name_contains(search)
        desc_filter = organizations.left_joins(:organization_descriptions)
                                   .where('LOWER(organization_descriptions.description) like LOWER(?)', "%#{search}%")
        organizations = organizations.where(id: (name_filter + desc_filter).uniq)
      end

      filtered_sectors = sectors.reject { |x| x.nil? || x.empty? }
      unless filtered_sectors.empty?
        organizations = organizations.joins(:sectors)
                                     .where(sectors: { id: filtered_sectors })
      end

      { total_count: organizations.count }
    end
  end
end
