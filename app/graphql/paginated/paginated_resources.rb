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
    argument :spotlight_only, Boolean, required: false, default_value: false
    argument :spotlight_length, Integer, required: false, default_value: 1

    argument :offset_attributes, Attributes::OffsetAttributes, required: true

    type [Types::ResourceType], null: false

    def resolve(
      search:, show_in_wizard:, show_in_exchange:, offset_attributes:, compartmentalized:,
      featured_only:, featured_length:, spotlight_only:, spotlight_length:,
      resource_types:, resource_topics:, tags:, countries:
    )
      # Sort resources by:
      # - spotlight
      # - featured
      # - published_date
      #
      # Offset calculation steps:
      # - Find spotlight resource
      # - If spotlight resource found, offset = offset + 1
      # - Return the next 3 resources
      #   - The 3 will be either all 3 featured resources or some

      resources = Resource
                  .order(spotlight: :desc)
                  .order(featured: :desc)
                  .order(published_date: :desc)

      current_offset = 0
      if compartmentalized
        spotlight_resources = resources.where(spotlight: true).limit(spotlight_length).offset(current_offset)
        return spotlight_resources if spotlight_only

        current_offset += spotlight_length unless spotlight_resources.empty?

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
          "resources.spotlight is true or resources.featured is true"
        )
      end

      resources = resources.where(show_in_exchange: true) if show_in_exchange
      resources = resources.where(show_in_wizard: true) if show_in_wizard

      resources = resources.where.not(id: spotlight_resources.ids) unless spotlight_resources.empty?
      resources = resources.where.not(id: featured_resources.ids) unless featured_resources.empty?

      # We need to add the following records to make sure we're returning the correct offset

      offset_params = offset_attributes.to_h
      resources.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
