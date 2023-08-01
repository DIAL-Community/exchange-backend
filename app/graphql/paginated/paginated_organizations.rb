# frozen_string_literal: true

module Paginated
  class PaginatedOrganizations < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :sectors, [String], required: false, default_value: []
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::OrganizationType], null: false

    def resolve(search:, sectors:, offset_attributes:)
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

      offset_params = offset_attributes.to_h
      organizations.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
