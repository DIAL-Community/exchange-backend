# frozen_string_literal: true

module Types
  class ResourceTopicDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :resource_topic_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class ResourceTopicType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :resource_topic_descriptions, [Types::ResourceTopicDescriptionType], null: true
    field :resource_topic_description, Types::ResourceTopicDescriptionType, null: true

    def resource_topic_description
      description = object.resource_topic_descriptions
                          .order(Arel.sql('LENGTH(description) DESC'))
                          .find_by(locale: I18n.locale)
      if description.nil?
        description = object.resource_topic_descriptions
                            .order(Arel.sql('LENGTH(description) DESC'))
                            .find_by(locale: 'en')
      end
      description
    end

    field :resources, [Types::ResourceType], null: false

    def resources
      Resource.where(
        "resource_topics @> '{#{object.name.downcase}}'::varchar[] or " \
        "resource_topics @> '{#{object.name}}'::varchar[]"
      )
    end
  end
end
