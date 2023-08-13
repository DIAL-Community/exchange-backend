# frozen_string_literal: true

module Paginated
  class PaginatedOpportunities < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :sectors, [String], required: false, default_value: []
    argument :tags, [String], required: false, default_value: []
    argument :offset_attributes, Attributes::OffsetAttributes, required: true

    type [Types::OpportunityType], null: false

    def resolve(search:, sectors:, tags:, offset_attributes:)
      opportunities = Opportunity.order(:name)
      unless search.blank?
        opportunities = opportunities.name_contains(search)
      end

      filtered_sectors = sectors.reject { |x| x.nil? || x.empty? }
      unless filtered_sectors.empty?
        opportunities = opportunities.joins(:sectors)
                                     .where(sectors: { id: filtered_sectors })
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
