# frozen_string_literal: true

class Author < ApplicationRecord
  has_and_belongs_to_many :resources, join_table: :resources_authors

  scope :name_contains, ->(name) { where('LOWER(authors.name) like LOWER(?)', "%#{name}%") }
end