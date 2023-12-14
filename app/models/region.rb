# frozen_string_literal: true

class Region < ApplicationRecord
  include Auditable
  has_and_belongs_to_many :countries, join_table: :regions_countries, dependent: :destroy

  scope :name_contains, ->(name) { where('LOWER(regions.name) like LOWER(?)', "%#{name}%") }
  scope :name_and_slug_search, -> (name, slug) { where('regions.name = ? OR regions.slug = ?', name, slug) }
end
