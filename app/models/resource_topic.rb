# frozen_string_literal: true

class ResourceTopic < ApplicationRecord
  has_many(:resource_topic_descriptions, dependent: :destroy)

  scope :name_contains,
        ->(name) { where('LOWER(resource_topics.name) like LOWER(?)', "%#{name}%") }
  scope :name_and_slug_search,
        -> (name, slug) { where('resource_topics.name = ? OR resource_topics.slug = ?', name, slug) }
end
