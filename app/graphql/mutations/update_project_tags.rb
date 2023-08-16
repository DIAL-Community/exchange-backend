# frozen_string_literal: true

module Mutations
  class UpdateProjectTags < Mutations::BaseMutation
    argument :tag_names, [String], required: true
    argument :slug, String, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: true

    def resolve(tag_names:, slug:)
      project = Project.find_by(slug:)

      unless an_admin || org_owner_check_for_project(project) ||
        product_owner_check_for_project(project)
        return {
          project: nil,
          errors: ['Must have proper rights to update a project']
        }
      end

      project.tags = []
      if !tag_names.nil? && !tag_names.empty?
        tag_names.each do |tag_name|
          tag = Tag.find_by(name: tag_name)
          project.tags << tag.name unless tag.nil?
        end
      end

      if project.save
        # Successful creation, return the created object with no errors
        {
          project:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          project: nil,
          errors: project.errors.full_messages
        }
      end
    end
  end
end
