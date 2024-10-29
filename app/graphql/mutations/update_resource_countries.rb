# frozen_string_literal: true

module Mutations
  class UpdateResourceCountries < Mutations::BaseMutation
    argument :country_slugs, [String], required: true
    argument :slug, String, required: true

    field :resource, Types::ResourceType, null: true
    field :errors, [String], null: true

    def resolve(country_slugs:, slug:)
      resource = Resource.find_by(slug:)
      resource_policy = Pundit.policy(context[:current_user], resource || Resource.new)
      if resource.nil? || !resource_policy.edit_allowed?
        return {
          resource: nil,
          errors: ['Editing resource is not allowed.']
        }
      end

      resource.countries = []
      if !country_slugs.nil? && !country_slugs.empty?
        country_slugs.each do |country_slug|
          current_country = Country.find_by(slug: country_slug)
          resource.countries << current_country unless current_country.nil?
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
