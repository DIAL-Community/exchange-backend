# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateRubricCategory < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :weight, Float, required: true
    argument :description, String, required: true

    field :rubric_category, Types::RubricCategoryType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, weight:, description:)
      rubric_category = RubricCategory.find_by(slug:)
      rubric_category_policy = Pundit.policy(context[:current_user], rubric_category || RubricCategory.new)

      if rubric_category.nil? && !rubric_category_policy.create_allowed?
        return {
          rubric_category: nil,
          errors: ['Creating / editing rubric category is not allowed.']
        }
      end

      if !rubric_category.nil? && !rubric_category_policy.edit_allowed?
        return {
          rubric_category: nil,
          errors: ['Creating / editing rubric category is not allowed.']
        }
      end

      if rubric_category.nil?
        slug = reslug_em(name)
        rubric_category = RubricCategory.new(name:, slug:)

        # Check if we need to add _dup to the slug.
        first_duplicate = RubricCategory.slug_simple_starts_with(slug)
                                        .order(slug: :desc)
                                        .first
        unless first_duplicate.nil?
          rubric_category.slug += generate_offset(first_duplicate)
        end
      end

      # allow user to rename rubric category but don't re-slug it
      rubric_category.name = name
      rubric_category.weight = weight

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(rubric_category)
        rubric_category.save!
        rubric_category_desc = RubricCategoryDescription.find_by(rubric_category_id: rubric_category.id,
                                                                 locale: I18n.locale)
        rubric_category_desc = RubricCategoryDescription.new if rubric_category_desc.nil?
        rubric_category_desc.description = description
        rubric_category_desc.rubric_category_id = rubric_category.id
        rubric_category_desc.locale = I18n.locale

        assign_auditable_user(rubric_category)
        rubric_category_desc.save!

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          rubric_category:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          rubric_category: nil,
          errors: rubric_category.errors.full_messages
        }
      end
    end
  end
end
