# frozen_string_literal: true

module Queries
  class RubricCategoryQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::RubricCategoryType, null: true

    def resolve(slug:)
      rubric_category = RubricCategory.find_by(slug:) if valid_slug?(slug)
      validate_access_to_resource(rubric_category || RubricCategory.new)
      rubric_category
    end
  end

  class RubricCategoriesQuery < Queries::BaseQuery
    argument :search, String, required: false
    type [Types::RubricCategoryType], null: false

    def resolve(search:)
      validate_access_to_resource(RubricCategory.new)
      rubric_categories = RubricCategory.order(:name)
      rubric_categories = RubricCategory.name_contains(search) unless search.blank?
      rubric_categories
    end
  end
end
