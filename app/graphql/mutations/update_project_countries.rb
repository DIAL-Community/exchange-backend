# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class UpdateProjectCountries < Mutations::BaseMutation
    include Modules::Slugger

    argument :country_slugs, [String], required: true
    argument :slug, String, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: true

    def resolve(country_slugs:, slug:)
      project = Project.find_by(slug:)

      unless an_admin || org_owner_check_for_project(project) ||
        product_owner_check_for_project(project)
        return {
          project: nil,
          errors: ['Must have proper rights to update a project']
        }
      end

      project.countries = []
      if !country_slugs.nil? && !country_slugs.empty?
        country_slugs.each do |country_slug|
          current_country = Country.find_by(slug: country_slug)
          project.countries << current_country unless current_country.nil?
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
