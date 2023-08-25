# frozen_string_literal: true

module Queries
  class CategoryIndicatorsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CategoryIndicatorType], null: false

    def resolve(search:)
      category_indicators = []
      if an_admin
        category_indicators = CategoryIndicator.where(rubric_category_id: nil)
        category_indicators = category_indicators.name_contains(search) unless search.blank?
      end
      category_indicators
    end
  end

  class CategoryIndicatorQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CategoryIndicatorType, null: true

    def resolve(slug:)
      category_indicator = CategoryIndicator.find_by(slug:) if an_admin
      category_indicator
    end
  end
end
