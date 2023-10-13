# frozen_string_literal: true

module Mutations
  class UpdateResourceTags < Mutations::BaseMutation
    argument :slug, String, required: true
    argument :tag_names, [String], required: true

    field :resource, Types::ResourceType, null: true
    field :errors, [String], null: true

    def resolve(tag_names:, slug:)
      resource = Resource.find_by(slug:)

      unless an_admin || a_content_editor
        return {
          resource: nil,
          errors: ['Must have proper rights to update a resource']
        }
      end

      resource.tags = []
      if !tag_names.nil? && !tag_names.empty?
        tag_names.each do |tag_name|
          tag = Tag.find_by(name: tag_name)
          resource.tags << tag.name unless tag.nil?
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
