# frozen_string_literal: true

module Mutations
  class UpdateResourceUseCases < Mutations::BaseMutation
    argument :use_case_slugs, [String], required: true
    argument :slug, String, required: true

    field :resource, Types::ResourceType, null: true
    field :errors, [String], null: true

    def resolve(use_case_slugs:, slug:)
      resource = Resource.find_by(slug:)

      unless an_admin || a_content_editor
        return {
          resource: nil,
          errors: ['Must have proper rights to update a resource']
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
