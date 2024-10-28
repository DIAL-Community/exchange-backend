# frozen_string_literal: true

module Mutations
  class DeleteTag < Mutations::BaseMutation
    argument :id, ID, required: true

    field :tag, Types::TagType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      tag = Tag.find_by(id:)
      tag_policy = Pundit.policy(context[:current_user], tag || Tag.new)
      if tag.nil? || !tag_policy.delete_allowed?
        return {
          tag: nil,
          errors: ['Deleting tag is not allowed.']
        }
      end

      assign_auditable_user(tag)

      successful_operation = false
      ActiveRecord::Base.transaction do
        delete_query = <<~SQL
          tags = ARRAY_REMOVE(tags, :tag_name)
        SQL
        sanitized_sql = ActiveRecord::Base.sanitize_sql([delete_query, { tag_name: tag.name }])
        Dataset.update_all(sanitized_sql)

        Playbook.update_all(sanitized_sql)
        Play.update_all(sanitized_sql)

        Product.update_all(sanitized_sql)
        Project.update_all(sanitized_sql)
        UseCase.update_all(sanitized_sql)
        Resource.update_all(sanitized_sql)

        tag.destroy!

        successful_operation = true
      end

      if successful_operation
        # Successful deletion, return the deleted tag with no errors
        {
          tag:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client.
        {
          tag: nil,
          errors: tag.errors.full_messages
        }
      end
    end
  end
end
