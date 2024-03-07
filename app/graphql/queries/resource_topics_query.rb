# frozen_string_literal: true

module Queries
  class ResourceTopicsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::ResourceTopicType], null: false

    def resolve(search:)
      topics = ResourceTopic.where(parent_topic_id: nil).order(:name)
      topics = tags.name_contains(search) unless search.blank?
      topics
    end
  end

  class ResourceTopicQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::ResourceTopicType, null: true

    def resolve(slug:)
      ResourceTopic.find_by(slug:)
    end
  end
end
