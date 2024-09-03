# frozen_string_literal: true

class SoftwareFeature < ApplicationRecord
  belongs_to :software_category
  has_and_belongs_to_many :products, join_table: :product_features

  scope :name_contains, ->(name) { where('LOWER(software_features.name) like LOWER(?)', "%#{name}%") }

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end
end
