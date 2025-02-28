# frozen_string_literal: true

module Paginated
  class PaginationAttributeOrganization < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :sectors, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []
    argument :years, [Int], required: false, default_value: []
    argument :aggregator_only, Boolean, required: false, default_value: false
    argument :endorser_only, Boolean, required: false, default_value: false

    type Attributes::PaginationAttributes, null: false

    def resolve(search:, sectors:, countries:, years:, aggregator_only:, endorser_only:)
      # Validate access to the current entity type.
      validate_access_to_resource(Organization.new)

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

      { total_count: organizations.count }
    end
  end
end
