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

    type Attributes::PaginationAttributes, null: false

    def resolve(
      search:, show_in_exchange:, show_in_wizard:, resource_types:, resource_topics:, tags:, countries:
    )
      if !unsecured_read_allowed && context[:current_user].nil?
        return { total_count: 0 }
      end

      resources = Resource
                  .order(featured: :desc)
                  .order(published_date: :desc)

      unless search.blank?
        name_filter = Resource.name_contains(search)
        description_filter = Resource.where('LOWER(description) like LOWER(?)', "%#{search}%")

        organization_sources = Organization.where('LOWER(name) like LOWER(?)', "%#{search}%")
        source_filter = Resource.where('organization_id IN (?)', organization_sources.ids)

        author_filter = Resource.joins(:authors)
                                .where('LOWER(authors.name) like LOWER(?)', "%#{search}%")
        organization_filter = Resource.joins(:organizations)
                                      .where('LOWER(organizations.name) like LOWER(?)', "%#{search}%")

        resources = resources.where(
          id: (name_filter + description_filter + author_filter + source_filter + organization_filter).uniq
        )
      end

      unless resource_types.empty?
        resources = resources.where(resource_type: resource_types)
      end

      filtered_resource_topics = resource_topics.reject { |x| x.nil? || x.blank? }
      unless filtered_resource_topics.empty?
        resources = resources.where(
          # https://www.postgresql.org/docs/current/functions-array.html
          "resources.resource_topics && '{#{filtered_resource_topics.join(',').downcase}}'::varchar[] or " \
          "resources.resource_topics && '{#{filtered_resource_topics.join(',')}}'::varchar[] "
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
          # https://www.postgresql.org/docs/current/functions-array.html
          " (resources.tags @> '{#{filtered_tags.join(',').downcase}}'::varchar[]) or " \
          " (resources.tags @> '{#{filtered_tags.join(',')}}'::varchar[]) "
        )
      end

      resources = resources.where(show_in_exchange: true) if show_in_exchange
      resources = resources.where(show_in_wizard: true) if show_in_wizard

      { total_count: resources.count }
    end
  end
end
