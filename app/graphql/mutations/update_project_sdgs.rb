# frozen_string_literal: true

module Mutations
  class UpdateProjectSdgs < Mutations::BaseMutation
    argument :sdg_slugs, [String], required: true
    argument :slug, String, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: true

    def resolve(sdg_slugs:, slug:)
      project = Project.find_by(slug:)
      project_policy = Pundit.policy(context[:current_user], project || Project.new)
      if project.nil? || !project_policy.edit_allowed?
        return {
          project: nil,
          errors: ['Editing project is not allowed.']
        }
      end

      project.sustainable_development_goals = []
      if !sdg_slugs.nil? && !sdg_slugs.empty?
        sdg_slugs.each do |sdg_slug|
          current_sdg = SustainableDevelopmentGoal.find_by(slug: sdg_slug)
          project.sustainable_development_goals << current_sdg unless current_sdg.nil?
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
