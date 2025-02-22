# frozen_string_literal: true

module Queries
  class OrganizationQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::OrganizationType, null: true

    def resolve(slug:)
      organization = Organization.find_by(slug:) if valid_slug?(slug)
      # Special handling for storefronts section where standard user is allowed to create record without
      # yet becoming the owner of the storefront record.
      organization_instance_resolver = Organization.new
      if context[:operation_name].to_s.downcase.include?(STOREFRONT_CONTEXT)
        organization_instance_resolver = Organization.new(has_storefront: true)
      end
      validate_access_to_instance(organization || organization_instance_resolver)
      organization
    end
  end

  class OrganizationsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :aggregator_only, Boolean, required: false, default_value: false

    type [Types::OrganizationType], null: false

    def resolve(search:, aggregator_only:)
      validate_access_to_resource(Organization.new)
      organizations = Organization.order(:name)
      organizations = organizations.name_contains(search) unless search.blank?
      organizations = organizations.where(is_mni: true) if aggregator_only
      organizations
    end
  end

  class SearchOrganizationsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :years, [Int], required: false, default_value: []
    argument :sectors, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []
    argument :aggregators, [String], required: false, default_value: []
    argument :aggregator_only, Boolean, required: false, default_value: false

    type [Types::OrganizationType], null: false

    def resolve(search:, years:, sectors:, countries:, aggregators:, aggregator_only:)
      validate_access_to_resource(Organization.new)
      organizations = Organization.order(:name)

      organizations = organizations.where(is_mni: true) if aggregator_only

      filtered_aggregators = aggregators.reject { |x| x.nil? || x.empty? }
      organizations = organizations.where(id: filtered_aggregators) unless filtered_aggregators.empty?

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

      organizations = organizations.where('extract(year from when_endorsed) in (?)', years) unless years.empty?

      organizations = organizations.eager_load(:countries, :offices).distinct
      organizations
    end
  end
end
