# frozen_string_literal: true

require 'modules/slugger'
require 'modules/geocode'

module Mutations
  class CreateProject < Mutations::BaseMutation
    include Modules::Slugger
    include Modules::Geocode

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :start_date, GraphQL::Types::ISO8601Date, required: false, default_value: nil
    argument :end_date, GraphQL::Types::ISO8601Date, required: false, default_value: nil
    argument :project_url, String, required: false, default_value: nil
    argument :description, String, required: true
    argument :product_id, Integer, required: false, default_value: nil
    argument :organization_id, Integer, required: false, default_value: nil
    argument :location, GraphQL::Types::JSON, required: false, default_value: nil
    argument :country_slugs, [String], required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, start_date:, end_date:, project_url:,
      description:, location:, product_id:, organization_id:,
      country_slugs:)
      project = Project.find_by(slug:)
      project_policy = Pundit.policy(context[:current_user], project || Project.new)
      if project.nil? && !project_policy.create_allowed?
        return {
          project: nil,
          errors: ['Creating / editing project is not allowed.']
        }
      end

      if !project.nil? && !project_policy.edit_allowed?
        return {
          project: nil,
          errors: ['Creating / editing project is not allowed.']
        }
      end

      if project.nil?
        project = Project.new(name:)
        project.slug = reslug_em(name)

        if Project.where(slug: project.slug).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Project.slug_simple_starts_with(project.slug)
                                   .order(slug: :desc)
                                   .first
          project.slug += generate_offset(first_duplicate)
        end
      end

      unless location.nil?
        project.location = location['name']
        project.latitude = location['latitude']
        project.longitude = location['longitude']
      end

      project.countries = []
      if !country_slugs.nil? && !country_slugs.empty?
        country_slugs.each do |country_slug|
          current_country = Country.find_by(slug: country_slug)
          project.countries << current_country unless current_country.nil?
        end
      end

      # allow user to rename project but don't re-slug it
      project.name = name
      project.start_date = start_date unless start_date.nil?
      project.end_date = end_date unless end_date.nil?
      project.project_url = project_url unless project_url.nil?

      # Defaulting to manually entered
      project.origin = Origin.find_by(slug: 'manually-entered') if project.origin.nil?

      unless product_id.nil?
        product = Product.find_by(id: product_id)
        project.products << product unless product.nil?
      end

      unless organization_id.nil?
        organization = Organization.find_by(id: organization_id)
        project.organizations << organization unless organization.nil?
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(project)
        project.save!

        project_desc = ProjectDescription.find_by(project_id: project.id, locale: I18n.locale)
        project_desc = ProjectDescription.new if project_desc.nil?
        project_desc.description = description
        project_desc.project_id = project.id
        project_desc.locale = I18n.locale

        assign_auditable_user(project_desc)
        project_desc.save!

        successful_operation = true
      end

      if successful_operation
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
