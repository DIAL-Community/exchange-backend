# frozen_string_literal: true

module Mutations
  class DeleteCategoryIndicator < Mutations::BaseMutation
    argument :id, ID, required: true

    field :category_indicator, Types::CategoryIndicatorType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      category_indicator = CategoryIndicator.find_by(id:)

      unless an_admin
        return {
          category_indicator: nil,
          rubric_category_slug: nil,
          errors: ['Must be admin to delete a category indicator']
        }
      end

      assign_auditable_user(category_indicator)
      if category_indicator.destroy
        # Successful deletion, return the deleted category indicator with no errors
        {
          category_indicator: nil,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          category_indicator:,
          errors: category_indicator.errors.full_messages
        }
      end
    end
  end
end
