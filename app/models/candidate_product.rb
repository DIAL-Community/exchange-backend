# frozen_string_literal: true

class CandidateProduct < ApplicationRecord
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }
  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end
end
