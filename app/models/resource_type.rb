# frozen_string_literal: true

class ResourceType < ApplicationRecord
  scope :name_contains, ->(name) { where('LOWER(resource_types.name) like LOWER(?)', "%#{name}%") }

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end
end
