# frozen_string_literal: true

module Mutations
  class DeleteCategory < Mutations::BaseMutation
    argument :id, ID, required: true

    field :category, Types::SoftwareCategoryType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          category: nil,
          errors: ['Must be admin to delete a software category.']
        }
      end

      category = SoftwareCategory.find_by(id:)
      
      if category.destroy
        # Successful deletion, return the deleted sector with no errors
        {
          category:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          category: nil,
          errors: category.errors.full_messages
        }
      end
    end
  end
end
