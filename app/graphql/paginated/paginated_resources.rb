# frozen_string_literal: true

module Paginated
  class PaginatedResources < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    argument :show_in_wizard, Boolean, required: false, default_value: false
    argument :show_in_exchange, Boolean, required: false, default_value: false

    argument :resource_types, [String], required: false, default_value: []
    argument :resource_topics, [String], required: false, default_value: []

    argument :tags, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []

    argument :compartmentalized, Boolean, required: true, default_value: false
    argument :featured_only, Boolean, required: false, default_value: false
    argument :featured_length, Integer, required: false, default_value: 3

    argument :offset_attributes, Attributes::OffsetAttributes, required: true

    type [Types::ResourceType], null: false

    def resolve(
      search:, show_in_wizard:, show_in_exchange:, offset_attributes:, compartmentalized:,
      featured_only:, featured_length:, resource_types:, resource_topics:, tags:, countries:
    )
      if !unsecure_read_allowed && context[:current_user].nil?
        return []
      end

      # Sort resources by:
      # - featured
      # - published_date
      #
      # Offset calculation steps:
      # - Return the 3 featured resources

      resources = Resource
                  .order(featured: :desc)
                  .order(published_date: :desc)

      current_offset = 0
      featured_resources = []
      if compartmentalized
        featured_resources = resources.where(featured: true).limit(featured_length).offset(current_offset)
        return featured_resources if featured_only
      end

      unless search.blank?
        resources = resources.name_contains(search)
      end

      unless resource_types.empty?
        resources = resources.where(resource_type: resource_types)
      end

      unless resource_topics.empty?
        resources = resources.where(resource_topic: resource_topics)
      end

      filtered_countries = countries.reject { |x| x.nil? || x.empty? }
      unless filtered_countries.empty?
        resources = resources.left_outer_joins(:countries)
                             .where(countries: { name: filtered_countries })
      end

      filtered_tags = tags.reject { |x| x.nil? || x.blank? }
      unless filtered_tags.empty?
        resources = resources.where(
          "resources.tags @> '{#{filtered_tags.join(',').downcase}}'::varchar[] or " \
          "resources.tags @> '{#{filtered_tags.join(',')}}'::varchar[] or " \
          "resources.featured is true"
        )
      end

      resources = resources.where(show_in_exchange: true) if show_in_exchange
      resources = resources.where(show_in_wizard: true) if show_in_wizard

      resources = resources.where.not(id: featured_resources.ids) unless featured_resources.empty?

      # We need to add the following records to make sure we're returning the correct offset

      offset_params = offset_attributes.to_h
      resources.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
