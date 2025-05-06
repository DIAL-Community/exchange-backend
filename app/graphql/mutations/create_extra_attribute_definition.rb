# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateExtraAttributeDefinition < Mutations::BaseMutation
    include Modules::Slugger

    argument :slug, String, required: true
    argument :name, String, required: true

    argument :attribute_type, String, required: true
    argument :attribute_required, Boolean, required: true, default_value: false

    argument :title, String, required: true
    argument :title_fallback, String, required: false, default_value: nil

    argument :description, String, required: true
    argument :description_fallback, String, required: false, default_value: nil

    argument :entity_types, [String], required: true

    argument :choices, [String], required: false, default_value: []
    argument :multiple_choice, Boolean, required: false, default_value: false

    argument :child_extra_attribute_names, [String], required: false, default_value: []

    field :extra_attribute_definition, Types::ExtraAttributeDefinitionType, null: true
    field :errors, [String], null: true

    def resolve(
      slug:, name:, attribute_type:, attribute_required:, title:, title_fallback:,
      description:, description_fallback:, entity_types:, multiple_choice:, choices:,
      child_extra_attribute_names:
    )
      # Find the extra attribute definition policy
      definition = ExtraAttributeDefinition.find_by(slug:)
      definition_policy = Pundit.policy(context[:current_user], definition || ExtraAttributeDefinition.new)

      if definition.nil? && !definition_policy.create_allowed?
        return {
          extra_attribute_definition: nil,
          errors: ['Creating / editing extra attribute definition is not allowed.']
        }
      end

      if definition.nil? && !definition_policy.edit_allowed?
        return {
          extra_attribute_definition: nil,
          errors: ['Creating / editing extra attribute definition is not allowed.']
        }
      end

      if definition.nil?
        definition = ExtraAttributeDefinition.new(name:, slug: reslug_em(title))
        # Check if we need to add _duplicate to the slug.
        first_duplicate = ExtraAttributeDefinition.slug_simple_starts_with(reslug_em(title))
                                                  .order(slug: :desc)
                                                  .first
        unless first_duplicate.nil?
          definition.slug += generate_offset(first_duplicate)
        end
      end

      # Re-slug if the name is updated (not the same with the one in the db).
      if definition.title != title
        definition.slug = reslug_em(title)

        # Check if we need to add _duplicate to the slug.
        first_duplicate = ExtraAttributeDefinition.slug_simple_starts_with(reslug_em(title))
                                                  .order(slug: :desc)
                                                  .first
        unless first_duplicate.nil?
          definition.slug += generate_offset(first_duplicate)
        end
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        definition.attribute_type = attribute_type
        definition.attribute_required = attribute_required

        definition.title = title
        definition.title_fallback = title_fallback

        definition.description = description
        definition.description_fallback = description_fallback

        definition.entity_types = entity_types

        definition.choices = choices
        definition.multiple_choice = multiple_choice

        child_extra_attribute_names.each do |child_extra_attribute_name|
          extra_attribute_definition = ExtraAttributeDefinition.find_by(name: child_extra_attribute_name)
          unless extra_attribute_definition.nil?
            definition.child_extra_attribute_names << extra_attribute_definition.name
          end
        end

        assign_auditable_user(definition)
        definition.save!

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          extra_attribute_definition: definition,
          errors: []
        }
      else
        # Failed save, return the errors to the client.
        # We will only reach this block if the transaction is failed.
        {
          extra_attribute_definition: nil,
          errors: definition.errors.full_messages
        }
      end
    end
  end
end
