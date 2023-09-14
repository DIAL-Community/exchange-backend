# frozen_string_literal: true

module Queries
  class OrganizationsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :aggregator_only, Boolean, required: false, default_value: false

    type [Types::OrganizationType], null: false

    def resolve(search:, aggregator_only:)
      organizations = Organization.order(:name)
      organizations = organizations.name_contains(search) unless search.blank?

      organizations = organizations.where(is_mni: true) if aggregator_only

      organizations
    end
  end

  class OrganizationQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::OrganizationType, null: true

    def resolve(slug:)
      Organization.find_by(slug:)
    end
  end

  class SearchOrganizationsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :years, [Int], required: false, default_value: []
    argument :sectors, [String], required: false, default_value: []
    argument :aggregators, [String], required: false, default_value: []
    argument :aggregator_only, Boolean, required: false, default_value: false

    type Types::OrganizationType.connection_type, null: false

    def resolve(search:, years:, sectors:, aggregators:, aggregator_only:)
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

      organizations = organizations.where('extract(year from when_endorsed) in (?)', years) unless years.empty?

      organizations = organizations.eager_load(:countries, :offices).distinct
      organizations
    end
  end
end
