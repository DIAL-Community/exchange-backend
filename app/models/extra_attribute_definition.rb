# frozen_string_literal: true

class ExtraAttributeDefinition < ApplicationRecord
  include Auditable
  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }
end
