# frozen_string_literal: true

module Queries
  class SoftwareCategoriesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::SoftwareCategoryType], null: false

    def resolve(search:)
      categories = SoftwareCategory.all.order(:name)
      categories = categories.name_contains(search) unless search.blank?
      categories
    end
  end

  class SoftwareCategoryQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::SoftwareCategoryType, null: true

    def resolve(slug:)
      SoftwareCategory.find_by(slug:)
    end
  end
end
