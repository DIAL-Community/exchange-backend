# frozen_string_literal: true

module Mutations
  class UpdateRubricCategoryIndicators < Mutations::BaseMutation
    argument :rubric_category_slug, String, required: true
    argument :category_indicator_slugs, [String], required: true

    field :rubric_category, Types::RubricCategoryType, null: true
    field :errors, [String], null: true

    def resolve(category_indicator_slugs:, rubric_category_slug:)
      rubric_category = RubricCategory.find_by(slug: rubric_category_slug)
      rubbric_category_policy = Pundit.policy(context[:current_user], rubric_category || RubricCategory.new)
      if rubric_category.nil? || !rubbric_category_policy.edit_allowed?
        return {
          rubric_category: nil,
          errors: ['Editing rubric category is not allowed.']
        }
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        category_indicators = []
        category_indicator_slugs.each do |slug|
          current_category_indicator = CategoryIndicator.find_by(slug:)
          category_indicators << current_category_indicator unless current_category_indicator.nil?
        end
        rubric_category.category_indicators = category_indicators
        rubric_category.save!

        successful_operation = true
      end

      if successful_operation
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
