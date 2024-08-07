# frozen_string_literal: true

class ResourceTopic < ApplicationRecord
  include Auditable

  has_many(:resource_topic_descriptions, dependent: :destroy)

  scope :name_contains,
        ->(name) { where('LOWER(resource_topics.name) like LOWER(?)', "%#{name}%") }
  scope :name_and_slug_search,
        -> (name, slug) { where('resource_topics.name = ? OR resource_topics.slug = ?', name, slug) }

  def image_file
    if File.exist?(File.join('public', 'assets', 'resource-topics', "#{slug}.png"))
      "/assets/resource-topics/#{slug}.png"
    else
      '/assets/resource-topics/resource-topic-placeholder.svg'
    end
  end
end
