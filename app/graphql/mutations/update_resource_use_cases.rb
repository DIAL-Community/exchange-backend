# frozen_string_literal: true

module Mutations
  class UpdateResourceUseCases < Mutations::BaseMutation
    argument :use_case_slugs, [String], required: true
    argument :slug, String, required: true

    field :resource, Types::ResourceType, null: true
    field :errors, [String], null: true

    def resolve(use_case_slugs:, slug:)
      resource = Resource.find_by(slug:)
      resource_policy = Pundit.policy(context[:current_user], resource || Resource.new)
      if resource.nil? || !resource_policy.edit_allowed?
        return {
          resource: nil,
          errors: ['Editing resource is not allowed.']
        }
      end

      resource.use_cases = []
      if !use_case_slugs.nil? && !use_case_slugs.empty?
        use_case_slugs.each do |use_case_slug|
          current_use_case = UseCase.find_by(slug: use_case_slug)
          resource.use_cases << current_use_case unless current_use_case.nil?
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
