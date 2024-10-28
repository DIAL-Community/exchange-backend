# frozen_string_literal: true

module Mutations
  class DeleteRubricCategory < Mutations::BaseMutation
    argument :id, ID, required: true

    field :rubric_category, Types::RubricCategoryType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      rubric_category = RubricCategory.find_by(id:)
      rubric_category_policy = Pundit.policy(context[:current_user], rubric_category || RubricCategory.new)
      if rubric_category.nil? || !rubric_category_policy.delete_allowed?
        return {
          rubric_category: nil,
          errors: ['Deleting rubric category is not allowed.']
        }
      end

      assign_auditable_user(rubric_category)

      if rubric_category.destroy
        # Successful deletion, return the deleted rubric category with no errors
        {
          rubric_category:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          rubric_category: nil,
          errors: rubric_category.errors.full_messages
        }
      end
    end
  end
end
