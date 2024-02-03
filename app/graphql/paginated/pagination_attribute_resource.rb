# frozen_string_literal: true

module Paginated
  class PaginationAttributeResource < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :show_in_exchange, Boolean, required: false, default_value: false
    argument :show_in_wizard, Boolean, required: false, default_value: false

    argument :resource_types, [String], required: false, default_value: []
    argument :resource_topics, [String], required: false, default_value: []

    argument :tags, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []

    argument :compartmentalized, Boolean, required: true, default_value: false
    argument :featured_length, Integer, required: false, default_value: 3

    type Attributes::PaginationAttributes, null: false

    def resolve(
      search:, show_in_exchange:, show_in_wizard:, compartmentalized:,
      featured_length:, resource_types:, resource_topics:, tags:, countries:
    )
      if !unsecure_read_allowed && context[:current_user].nil?
        return { total_count: 0 }
      end

      resources = Resource
                  .order(featured: :desc)
                  .order(published_date: :desc)

      current_offset = 0
      if compartmentalized
        current_offset += featured_length
      end

      unless search.blank?
        resources = resources.name_contains(search)
      end

      unless resource_types.empty?
        resources = resources.where(resource_type: resource_types)
      end

      filtered_resource_topics = resource_topics.reject { |x| x.nil? || x.blank? }
      unless filtered_tags.empty?
        resources = resources.where(
          "resources.resource_topics @> '{#{filtered_resource_topics.join(',').downcase}}'::varchar[] or " \
          "resources.resource_topics @> '{#{filtered_resource_topics.join(',')}}'::varchar[] "
        )
      end

      filtered_countries = countries.reject { |x| x.nil? || x.empty? }
      unless filtered_countries.empty?
        resources = resources.joins(:countries)
                             .where(countries: { id: filtered_countries })
      end

      filtered_tags = tags.reject { |x| x.nil? || x.blank? }
      unless filtered_tags.empty?
        resources = resources.where(
          "resources.tags @> '{#{filtered_tags.join(',').downcase}}'::varchar[] or " \
          "resources.tags @> '{#{filtered_tags.join(',')}}'::varchar[]"
        )
      end

      resources = resources.where(show_in_exchange: true) if show_in_exchange
      resources = resources.where(show_in_wizard: true) if show_in_wizard

      resource_count = resources.count - current_offset

      { total_count: resource_count <= 0 ? 0 : resource_count }
    end
  end
end
