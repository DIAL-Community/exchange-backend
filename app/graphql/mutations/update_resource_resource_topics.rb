# frozen_string_literal: true

module Mutations
  class UpdateResourceResourceTopics < Mutations::BaseMutation
    argument :resource_topic_names, [String], required: true
    argument :slug, String, required: true

    field :resource, Types::ResourceType, null: true
    field :errors, [String], null: true

    def resolve(resource_topic_names:, slug:)
      resource = Resource.find_by(slug:)
      resource_policy = Pundit.policy(context[:current_user], resource || Resource.new)
      if resource.nil? || !resource_policy.edit_allowed?
        return {
          resource: nil,
          errors: ['Editing resource is not allowed.']
        }
      end

      resource.resource_topics = []
      if !resource_topic_names.nil? && !resource_topic_names.empty?
        resource_topic_names.each do |resource_topic_name|
          resource_topic = ResourceTopic.find_by(name: resource_topic_name)
          resource.resource_topics << resource_topic.name unless resource_topic.nil?
        end
      end

      if resource.save
        # Successful creation, return the created object with no errors
        {
          resource:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          resource: nil,
          errors: resource.errors.full_messages
        }
      end
    end
  end
end
