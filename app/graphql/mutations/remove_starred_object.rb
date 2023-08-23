# frozen_string_literal: true

module Mutations
  class RemoveStarredObject < Mutations::BaseMutation
    argument :starred_object_type, String, required: true
    argument :starred_object_value, String, required: true
    argument :source_object_type, String, required: true
    argument :source_object_value, String, required: true

    field :starred_object, Types::StarredObjectType, null: true
    field :errors, [String], null: true

    def resolve(starred_object_type:, starred_object_value:, source_object_type:, source_object_value:)
      if context[:current_user].nil?
        return {
          starred_object: nil,
          errors: ['Must be logged in to remove starred object.']
        }
      end

      starred_object = StarredObject.find_by(
        source_object_type:,
        source_object_value:,
        starred_object_type:,
        starred_object_value:
      )

      if starred_object.destroy
        # Successful creation, return the created object with no errors
        {
          starred_object:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          starred_object: nil,
          errors: starred_object.errors.full_messages
        }
      end
    end
  end
end
