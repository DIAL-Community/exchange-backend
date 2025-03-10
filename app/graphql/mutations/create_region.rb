# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateRegion < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :description, String, required: true
    argument :aliases, GraphQL::Types::JSON, required: false, default_value: []

    field :region, Types::RegionType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, description:, aliases:)
      region = Region.find_by(slug:)
      region_policy = Pundit.policy(context[:current_user], region || Region.new)

      if region.nil? && !region_policy.create_allowed?
        return {
          region: nil,
          errors: ['Creating / editing region is not allowed.']
        }
      end

      if !region.nil? && !region_policy.edit_allowed?
        return {
          region: nil,
          errors: ['Creating / editing region is not allowed.']
        }
      end

      region = Region.find_by(slug:)
      if region.nil?
        region = Region.new(name:, slug: reslug_em(name))

        # Check if we need to add _dup to the slug.
        first_duplicate = Region.slug_simple_starts_with(region.slug)
                                .order(slug: :desc)
                                .first
        unless first_duplicate.nil?
          region.slug += generate_offset(first_duplicate)
        end
      end

      assign_auditable_user(region)

      # Update field of the region object
      region.name = name
      region.description = description
      region.aliases = aliases

      if region.save
        # Successful creation, return the created object with no errors
        {
          region:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          region: nil,
          errors: region.errors.full_messages
        }
      end
    end
  end
end
