# frozen_string_literal: true

module Mutations
  class UpdateOpportunityUseCases < Mutations::BaseMutation
    argument :use_case_slugs, [String], required: true
    argument :slug, String, required: true

    field :opportunity, Types::OpportunityType, null: true
    field :errors, [String], null: true

    def resolve(use_case_slugs:, slug:)
      opportunity = Opportunity.find_by(slug: slug)

      unless an_admin
        return {
          opportunity: nil,
          errors: ['Must have proper rights to update an opportunity']
        }
      end

      opportunity.use_cases = []
      if !use_case_slugs.nil? && !use_case_slugs.empty?
        use_case_slugs.each do |use_case_slug|
          current_use_case = UseCase.find_by(slug: use_case_slug)
          opportunity.use_cases << current_use_case unless current_use_case.nil?
        end
      end

      if opportunity.save
        # Successful creation, return the created object with no errors
        {
          opportunity: opportunity,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          opportunity: nil,
          errors: opportunity.errors.full_messages
        }
      end
    end
  end
end
