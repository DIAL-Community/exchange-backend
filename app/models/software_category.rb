# frozen_string_literal: true

class SoftwareCategory < ApplicationRecord
  has_many :software_features
  has_and_belongs_to_many :products, join_table: :product_categories

  scope :name_contains, ->(name) { where('LOWER(software_categories.name) like LOWER(?)', "%#{name}%") }

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end
end
