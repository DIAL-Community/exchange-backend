# frozen_string_literal: true

class CandidateProduct < ApplicationRecord
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }
  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }

  has_many :candidate_product_category_indicators, dependent: :delete_all
  belongs_to :candidate_status, optional: true

  def update_extra_attributes(name:, value:, type: nil, index: nil, title: nil, description: nil)
    self.extra_attributes ||= []

    attribute = extra_attributes.find { |attr| attr['name'] == name }

    if attribute
      # Update the existing attribute with the new value.
      attribute['value'] = value
      # Set the optional fields if they are present.
      attribute['type'] = type if type
      attribute['index'] = index if index
      attribute['title'] = title if title
      attribute['description'] = description if description
    else
      # Add a new extra attribute entry to the extra attribute list.
      self.extra_attributes << {
        'name' => name,
        'value' => value,
        # Set the optional fields if they are present.
        'type' => type,
        'index' => index,
        'title' => title,
        'description' => description
      }
    end
  end

  def overall_maturity_score
    return nil if maturity_score.nil?

    maturity_score['overallScore'].is_a?(Numeric) ? maturity_score['overallScore'].to_f : nil
  end

  def maturity_score_details
    return [] if maturity_score.nil?

    maturity_score['rubricCategories']
  end

  def candidate_product_category_indicators
    CandidateProductCategoryIndicator
      .joins(:category_indicator)
      .where(candidate_product_id: id)
      .where.not(category_indicator: { rubric_category: nil })
  end

  def not_assigned_category_indicators
    assigned_category_indicators =
      CandidateProductCategoryIndicator
      .joins(:category_indicator)
      .where(candidate_product_id: id)
      .where.not(category_indicator: { rubric_category: nil })
    CategoryIndicator.where.not(id: assigned_category_indicators.map(&:category_indicator_id))
  end

  # overridden
  def generate_slug
    self.slug = reslug_em(name, 64)
  end
end
