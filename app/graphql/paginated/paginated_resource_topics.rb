# frozen_string_literal: true

module Paginated
  class PaginatedResourceTopics < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::ResourceTopicType], null: false

    def resolve(search:, offset_attributes:)
      # Validate access to the current entity type.
      validate_access_to_resource(ResourceTopic.new)

      resource_topics = ResourceTopic.where(parent_topic_id: nil).order(:name)
      unless search.blank?
        name_filter = resource_topics.name_contains(search)

        description_query = 'LOWER(resource_topic_descriptions.description) like LOWER(?)'
        description_filter = resource_topics.left_joins(:resource_topic_descriptions)
                                            .where(description_query, "%#{search}%")
        resource_topics = resource_topics.where(id: (name_filter + description_filter).uniq)
      end

      offset_params = offset_attributes.to_h
      resource_topics.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
