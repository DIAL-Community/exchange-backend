# frozen_string_literal: true

module Mutations
  class UpdateOpportunityTags < Mutations::BaseMutation
    argument :tag_names, [String], required: true
    argument :slug, String, required: true

    field :opportunity, Types::OpportunityType, null: true
    field :errors, [String], null: true

    def resolve(tag_names:, slug:)
      opportunity = Opportunity.find_by(slug:)

      unless an_admin
        return {
          opportunity: nil,
          errors: ['Must be admin to update an opportunity']
        }
      end

      opportunity.tags = []
      if !tag_names.nil? && !tag_names.empty?
        tag_names.each do |tag_name|
          tag = Tag.find_by(name: tag_name)
          opportunity.tags << tag.name unless tag.nil?
        end
      end

      if opportunity.save
        # Successful creation, return the created object with no errors
        {
          opportunity:,
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
