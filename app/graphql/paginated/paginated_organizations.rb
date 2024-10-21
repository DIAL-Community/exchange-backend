# frozen_string_literal: true

module Paginated
  class PaginatedOrganizations < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :sectors, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []
    argument :years, [Int], required: false, default_value: []
    argument :aggregator_only, Boolean, required: false, default_value: false
    argument :endorser_only, Boolean, required: false, default_value: false
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::OrganizationType], null: false

    def resolve(search:, sectors:, countries:, years:, aggregator_only:, endorser_only:, offset_attributes:)
      if !unsecured_read_allowed && context[:current_user].nil?
        return []
      end

      organizations = Organization.order(:name)
      organizations = organizations.where(is_mni: true) if aggregator_only
      organizations = organizations.where(is_endorser: true) if endorser_only

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

      filtered_countries = countries.reject { |x| x.nil? || x.empty? }
      unless filtered_countries.empty?
        organizations = organizations.joins(:countries)
                                     .where(countries: { id: filtered_countries })
      end

      unless years.empty?
        organizations = organizations.where('extract(year from when_endorsed) in (?)', years)
      end

      offset_params = offset_attributes.to_h
      organizations.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
