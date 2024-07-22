# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateCategory < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :description, String, required: false, default_value: nil

    field :category, Types::SoftwareCategoryType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, description:)
      unless an_admin
        return {
          category: nil,
          errors: ['Must be admin or content editor to create a software category']
        }
      end

      category = SoftwareCategory.find_by(slug:)
      if category.nil?
        category = SoftwareCategory.new(name:, slug: reslug_em(name))

        # Check if we need to add _dup to the slug.
        first_duplicate = SoftwareCategory.slug_simple_starts_with(category.slug)
                                .order(slug: :desc)
                                .first
        unless first_duplicate.nil?
          category.slug = category.slug + generate_offset(first_duplicate)
        end
      end

      # Update field of the sector object
      category.name = name
      category.description = description

      if category.save
        # Successful creation, return the created object with no errors
        {
          category:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          category: nil,
          errors: category.errors.full_messages
        }
      end
    end
  end
end
