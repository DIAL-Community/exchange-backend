# frozen_string_literal: true

module Mutations
  class DeleteCategoryIndicator < Mutations::BaseMutation
    argument :id, ID, required: true

    field :category_indicator, Types::CategoryIndicatorType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      category_indicator = CategoryIndicator.find_by(id:)
      category_indicator_policy = Pundit.policy(context[:current_user], category_indicator || CategoryIndicator.new)
      if category_indicator.nil? || !category_indicator_policy.delete_allowed?
        return {
          category_indicator: nil,
          rubric_category_slug: nil,
          errors: ['Deleting category indicator is not allowed.']
        }
      end

      assign_auditable_user(category_indicator)
      if category_indicator.destroy
        # Successful deletion, return the deleted category indicator with no errors
        {
          category_indicator:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          category_indicator: nil,
          errors: category_indicator.errors.full_messages
        }
      end
    end
  end
end
