# frozen_string_literal: true

module Paginated
  class PaginationAttributeResourceTopic < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      if !unsecure_read_allowed && context[:current_user].nil?
        return { total_count: 0 }
      end

      resource_topics = ResourceTopic.order(:name)
      unless search.blank?
        name_filter = resource_topics.name_contains(search)

        description_query = 'LOWER(resource_topic_descriptions.description) like LOWER(?)'
        description_filter = resource_topics.left_joins(:resource_topic_descriptions)
                                            .where(description_query, "%#{search}%")
        resource_topics = resource_topics.where(id: (name_filter + description_filter).uniq)
      end

      { total_count: resource_topics.count }
    end
  end
end
