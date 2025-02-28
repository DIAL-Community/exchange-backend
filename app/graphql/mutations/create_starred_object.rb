# frozen_string_literal: true

module Mutations
  class CreateStarredObject < Mutations::BaseMutation
    argument :starred_object_type, String, required: true
    argument :starred_object_value, String, required: true
    argument :source_object_type, String, required: true
    argument :source_object_value, String, required: true

    field :starred_object, Types::StarredObjectType, null: true
    field :errors, [String], null: true

    def resolve(starred_object_type:, starred_object_value:, source_object_type:, source_object_value:)
      starred_object_policy = Pundit.policy(context[:current_user], StarredObject.new)
      unless starred_object_policy.create_allowed?
        return {
          starred_object: nil,
          errors: ['Creating starred object is not allowed.']
        }
      end

      source_object = resolve_object(source_object_type, source_object_value)
      if source_object.nil?
        return {
          starred_object: nil,
          errors: ['Unable to resolve source object.']
        }
      end

      starred_object = resolve_object(starred_object_type, starred_object_value)
      if starred_object.nil?
        return {
          starred_object: nil,
          errors: ['Unable to resolve starred object.']
        }
      end

      # Update field of the sector object
      starred_object = StarredObject.new
      starred_object.starred_object_type = starred_object_type
      starred_object.starred_object_value = starred_object_value
      starred_object.source_object_type = source_object_type
      starred_object.source_object_value = source_object_value

      starred_object.starred_by_id = context[:current_user].id
      starred_object.starred_date = Time.now

      if starred_object.save
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

    def resolve_object(object_type_hint, object_identifier)
      case object_type_hint
      when StarredObject.object_type_names[:ORGANIZATION]
        Organization.find_by(id: object_identifier.to_i)
      when StarredObject.object_type_names[:PROJECT]
        Project.find_by(id: object_identifier.to_i)
      end
    end
  end
end
