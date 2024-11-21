# frozen_string_literal: true

module Mutations
  class UpdateUseCaseTags < Mutations::BaseMutation
    argument :tag_names, [String], required: true
    argument :slug, String, required: true

    field :use_case, Types::UseCaseType, null: true
    field :errors, [String], null: true

    def resolve(tag_names:, slug:)
      use_case = UseCase.find_by(slug:)
      use_case_policy = Pundit.policy(context[:current_user], use_case || UseCase.new)
      if use_case.nil? || !use_case_policy.edit_allowed?
        return {
          use_case: nil,
          errors: ['Editing use case is not allowed.']
        }
      end

      use_case.tags = []
      if !tag_names.nil? && !tag_names.empty?
        tag_names.each do |tag_name|
          tag = Tag.find_by(name: tag_name)
          use_case.tags << tag.name unless tag.nil?
        end
      end

      if use_case.save
        # Successful creation, return the created object with no errors
        {
          use_case:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          use_case: nil,
          errors: use_case.errors.full_messages
        }
      end
    end
  end
end
