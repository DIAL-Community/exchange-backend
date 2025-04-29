# frozen_string_literal: true

module Mutations
  class DeleteExtraAttributeDefinition < Mutations::BaseMutation
    argument :id, ID, required: true

    field :extra_attribute_definition, Types::ExtraAttributeDefinitionType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      definition = ExtraAttributeDefinition.find_by(id:)
      definition = Pundit.policy(context[:current_user], definition || ExtraAttributeDefinition.new)
      if definition.nil? || definition.delete_allowed?
        return {
          extra_attribute_definition: nil,
          errors: ['Deleting extra_attribute_definition is not allowed.']
        }
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(definition)
        definition.destroy!
        successful_operation = true
      end

      if successful_operation
        # Successful deletion, return the deleted extra_attribute_definition with no errors
        {
          extra_attribute_definition: definition,
          errors: []
        }
      else
        # Failed delete, return the errors to the client.
        {
          extra_attribute_definition: nil,
          errors: extra_attribute_definition.errors.full_messages
        }
      end
    end
  end
end
