# frozen_string_literal: true

module Mutations
  class DeleteResourceTopic < Mutations::BaseMutation
    argument :id, ID, required: true

    field :resource_topic, Types::ResourceTopicType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      resource_topic = ResourceTopic.find_by(id:)
      resource_topic_policy = Pundit.policy(context[:current_user], resource_topic || ResourceTopic.new)
      if resource_topic.nil? || !resource_topic_policy.delete_allowed?
        return {
          resource_topic: nil,
          errors: ['Deleting resource topic is not allowed.']
        }
      end

      assign_auditable_user(resource_topic)

      successful_operation = false
      ActiveRecord::Base.transaction do
        delete_query = <<~SQL
          resource_topics = ARRAY_REMOVE(resource_topics, :resource_topic_name)
        SQL
        sanitized_sql = ActiveRecord::Base.sanitize_sql([delete_query, { resource_topic_name: resource_topic.name }])
        Resource.update_all(sanitized_sql)

        resource_topic.destroy!

        successful_operation = true
      end

      if successful_operation
        # Successful deletion, return the deleted resource_topic with no errors
        {
          resource_topic:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client.
        {
          resource_topic: nil,
          errors: resource_topic.errors.full_messages
        }
      end
    end
  end
end
