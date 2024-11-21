# frozen_string_literal: true

module Mutations
  class UpdateProjectSectors < Mutations::BaseMutation
    argument :sector_slugs, [String], required: true
    argument :slug, String, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: true

    def resolve(sector_slugs:, slug:)
      project = Project.find_by(slug:)
      project_policy = Pundit.policy(context[:current_user], project || Project.new)
      if project.nil? || !project_policy.edit_allowed?
        return {
          project: nil,
          errors: ['Editing project is not allowed.']
        }
      end

      project.sectors = []
      if !sector_slugs.nil? && !sector_slugs.empty?
        sector_slugs.each do |sector_slug|
          current_sector = Sector.where("slug in (?)", sector_slug)
          project.sectors << current_sector unless current_sector.nil?
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
