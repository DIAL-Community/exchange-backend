# frozen_string_literal: true

module Paginated
  class PaginatedOpportunities < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :countries, [String], required: false, default_value: []
    argument :building_blocks, [String], required: false, default_value: []
    argument :organizations, [String], required: false, default_value: []
    argument :use_cases, [String], required: false, default_value: []
    argument :sectors, [String], required: false, default_value: []
    argument :tags, [String], required: false, default_value: []
    argument :show_closed, Boolean, required: false, default_value: false
    argument :offset_attributes, Attributes::OffsetAttributes, required: true

    type [Types::OpportunityType], null: false

    def resolve(
      search:,
      countries:,
      building_blocks:,
      organizations:,
      use_cases:,
      sectors:,
      tags:,
      show_closed:,
      offset_attributes:
    )
      opportunities = Opportunity.order_by_status.order(:closing_date)
      unless search.blank?
        description_query = 'LOWER(opportunities.description) like LOWER(?)'
        searching_description = Opportunity.where(description_query, "%#{search}%")
        opportunities = opportunities.name_contains(search)
                                     .or(searching_description)
      end

      filtered_sectors = sectors.reject { |x| x.nil? || x.empty? }
      unless filtered_sectors.empty?
        opportunities = opportunities.joins(:sectors)
                                     .where(sectors: { id: filtered_sectors })
      end

      filtered_countries = countries.reject { |x| x.nil? || x.empty? }
      unless filtered_countries.empty?
        opportunities = opportunities.joins(:countries)
                                     .where(countries: { id: filtered_countries })
      end

      filtered_organizations = organizations.reject { |x| x.nil? || x.empty? }
      unless filtered_organizations.empty?
        opportunities = opportunities.joins(:organizations)
                                     .where(organizations: { id: filtered_organizations })
      end

      filtered_use_cases = use_cases.reject { |x| x.nil? || x.empty? }
      unless filtered_use_cases.empty?
        opportunities = opportunities.joins(:use_cases)
                                     .where(use_cases: { id: filtered_use_cases })
      end

      filtered_building_blocks = building_blocks.reject { |x| x.nil? || x.empty? }
      unless filtered_building_blocks.empty?
        opportunities = opportunities.joins(:building_blocks)
                                     .where(building_blocks: { id: filtered_building_blocks })
      end

      unless show_closed
        opportunities = opportunities.where.not(opportunity_status: 'CLOSED')
      end

      filtered_tags = tags.reject { |x| x.nil? || x.blank? }
      unless filtered_tags.empty?
        opportunities = opportunities.where(
          "tags @> '{#{filtered_tags.join(',').downcase}}'::varchar[] or " \
          "tags @> '{#{filtered_tags.join(',')}}'::varchar[]"
        )
      end

      offset_params = offset_attributes.to_h
      opportunities.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end