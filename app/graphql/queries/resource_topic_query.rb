# frozen_string_literal: true

module Queries
  class ResourceTopicQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::ResourceTopicType, null: true

    def resolve(slug:)
      resource_topic = ResourceTopic.find_by(slug:) if valid_slug?(slug)
      validate_access_to_resource(resource_topic || ResourceTopic.new)
      resource_topic
    end
  end

  class ResourceTopicsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::ResourceTopicType], null: false

    def resolve(search:)
      validate_access_to_resource(ResourceTopic.new)
      topics = ResourceTopic.where(parent_topic_id: nil).order(:name)
      topics = topics.name_contains(search) unless search.blank?
      topics
    end
  end

  class ResourceTopicResourcesQuery < Queries::BaseQuery
    argument :slug, String, required: true
    argument :search, String, required: false, default_value: ''
    argument :resource_types, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []
    type [Types::ResourceType], null: true

    def resolve(slug:, search:, resource_types:, countries:)
      resource_topic_resources = Resource.all

      resource_topic = ResourceTopic.find_by(slug:) unless slug.blank?
      unless resource_topic.nil?
        resource_topic_where_clause = "resources.resource_topics @> '{#{resource_topic.name}}'::varchar[]"
        resource_topic_resources = Resource.where(resource_topic_where_clause)
      end

      if resource_topic.nil? && slug == 'with-topic-only'
        resource_topic_resources = resource_topic_resources.where("resources.resource_topics::text <> '{}'::text")
      end

      unless search.blank?
        name_filter = Resource.name_contains(search)
        description_filter = Resource.where('LOWER(description) like LOWER(?)', "%#{search}%")

        resource_topic_resources = resource_topic_resources.where(
          id: (name_filter + description_filter).uniq
        )
      end

      unless resource_types.empty?
        resource_topic_resources = resource_topic_resources.where(resource_type: resource_types)
      end

      filtered_countries = countries.reject { |x| x.nil? || x.empty? }
      unless filtered_countries.empty?
        resource_topic_resources = resource_topic_resources.left_outer_joins(:countries)
                                                           .where(countries: { name: filtered_countries })
      end

      resource_topic_resources
    end
  end
end
