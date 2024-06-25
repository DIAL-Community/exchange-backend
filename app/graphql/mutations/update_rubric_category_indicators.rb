# frozen_string_literal: true


module Mutations
  class UpdateRubricCategoryIndicators < Mutations::BaseMutation
    argument :category_indicator_slugs, [String], required: true
    argument :rubric_category_slug, String, required: true

    field :rubric_category, Types::RubricCategoryType, null: true
    field :errors, [String], null: true

    def resolve(category_indicator_slugs:, rubric_category_slug:)
      unless an_admin || a_content_editor
        return {
          rubric_category: nil,
          errors: ['Must be admin or content editor to update rubric category.']
        }
      end
      rubric_category = RubricCategory.find_by(slug: rubric_category_slug)

      rubric_category.category_indicators.each do |category_indicator|
        unless category_indicator_slugs.include?(category_indicator.slug)
          category_indicator.rubric_category_id = nil
          category_indicator.save!
        end
      end

      category_indicator_slugs.each do |slug|
        current_category_indicator = CategoryIndicator.find_by(slug:)
        rubric_category.category_indicators << current_category_indicator
      end

      rubric_category = RubricCategory.find_by(slug: rubric_category.slug)

      if rubric_category.save
        # Successful creation, return the created object with no errors
        {
          rubric_category:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          rubric_category: nil,
          errors: category_indicator.errors.full_messages
        }
      end
    end
  end
end
