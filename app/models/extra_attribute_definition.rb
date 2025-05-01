# frozen_string_literal: true

class ExtraAttributeDefinition < ApplicationRecord
  include Auditable
  scope :title_contains, ->(name) { where('LOWER(title) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }
end
