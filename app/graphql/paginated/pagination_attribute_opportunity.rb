# frozen_string_literal: true

module Paginated
  class PaginationAttributeOpportunity < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :sectors, [String], required: false, default_value: []

    type Attributes::PaginationAttributes, null: false

    def resolve(search:, sectors:)
      opportunities = Opportunity.order(:name)
      unless search.blank?
        opportunities = opportunities.name_contains(search)
        opportunities = opportunities.where('LOWER(description) like LOWER(?)', "%#{search}%")
      end

      filtered_sectors = sectors.reject { |x| x.nil? || x.empty? }
      unless filtered_sectors.empty?
        opportunities = opportunities.joins(:sectors)
                                     .where(sectors: { id: filtered_sectors })
      end

      { total_count: opportunities.count }
    end
  end
end
