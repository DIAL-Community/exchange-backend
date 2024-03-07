# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateResourceTopic < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :description, String, required: false
    argument :parent_topic_id, ID, required: false

    field :resource_topic, Types::ResourceTopicType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, description:, parent_topic_id: nil)
      unless an_admin
        return {
          resource_topic: nil,
          errors: ['Must be an admin to create / edit a resource topic']
        }
      end

      # Prevent duplicating resource_topic by the name of the resource_topic.
      resource_topic = ResourceTopic.find_by(slug:)
      if resource_topic.nil?
        resource_topic = ResourceTopic.find_by(name:)
      end

      if resource_topic.nil?
        resource_topic = ResourceTopic.new(name:, slug: reslug_em(name))
      end

      # Not a new record and current name is different with the existing name.
      updating_name = !resource_topic.new_record? && resource_topic.name != name

      successful_operation = false
      ActiveRecord::Base.transaction do
        if updating_name
          update_query = <<~SQL
            resource_topics =
            ARRAY_APPEND(
              ARRAY_REMOVE(resource_topics, :existing_resource_topic_name),
              :resource_topic_name
            )
            WHERE :existing_resource_topic_name = ANY(resource_topics)
          SQL
          sanitized_update = ActiveRecord::Base.sanitize_sql([
            update_query,
            { resource_topic_name: name, existing_resource_topic_name: resource_topic.name }
          ])

          Resource.update_all(sanitized_update)
        end

        resource_topic.name = name
        resource_topic.parent_topic_id = parent_topic_id

        assign_auditable_user(resource_topic)
        resource_topic.save!

        resource_topic_description = ResourceTopicDescription.find_by(
          resource_topic_id: resource_topic.id,
          locale: I18n.locale
        )
        resource_topic_description = ResourceTopicDescription.new if resource_topic_description.nil?
        resource_topic_description.description = description
        resource_topic_description.resource_topic_id = resource_topic.id
        resource_topic_description.locale = I18n.locale

        assign_auditable_user(resource_topic_description)
        resource_topic_description.save!

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          resource_topic:,
          errors: []
        }
      else
        # Failed save, return the errors to the client.
        # We will only reach this block if the transaction is failed.
        {
          resource_topic: nil,
          errors: resource_topic.errors.full_messages
        }
      end
    end
  end
end
