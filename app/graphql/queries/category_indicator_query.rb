# frozen_string_literal: true

module Queries
  class CategoryIndicatorQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CategoryIndicatorType, null: true

    def resolve(slug:)
      validate_access_to_resource(CategoryIndicator.new)
      category_indicator = CategoryIndicator.find_by(slug:) unless slug.blank?
      category_indicator
    end
  end

  class CategoryIndicatorsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CategoryIndicatorType], null: false

    def resolve(search:)
      validate_access_to_resource(CategoryIndicator.new)
      category_indicators = CategoryIndicator.order(:name)
      category_indicators = category_indicators.where(rubric_category_id: nil)
      category_indicators = category_indicators.name_contains(search) unless search.blank?
      category_indicators
    end
  end
end
