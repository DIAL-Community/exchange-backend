# frozen_string_literal: true

class CategoryIndicator < ApplicationRecord
  attribute :category_indicator_type, :string
  enum category_indicator_type: { boolean: 'boolean', numeric: 'numeric', scale: 'scale' }

  attr_accessor :ci_desc

  belongs_to :rubric_category, optional: true
  has_many :category_indicator_descriptions, dependent: :destroy
  has_many :product_indicators, dependent: :destroy

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end

  def category_indicator_description_localized
    description = category_indicator_descriptions
                  .find_by(locale: I18n.locale)
    if description.nil?
      description = category_indicator_descriptions
                    .find_by(locale: 'en')
    end
    description
  end

  def rubric_category
    RubricCategory.find_by(id: rubric_category_id)
  end
end
