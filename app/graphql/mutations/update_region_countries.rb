# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class UpdateRegionCountries < Mutations::BaseMutation
    include Modules::Slugger

    argument :country_slugs, [String], required: true
    argument :slug, String, required: true

    field :region, Types::RegionType, null: true
    field :errors, [String], null: true

    def resolve(country_slugs:, slug:)
      region = Region.find_by(slug:)

      unless an_admin
        return {
          region: nil,
          errors: ['Must have proper rights to update a region']
        }
      end

      region.countries = []
      if !country_slugs.nil? && !country_slugs.empty?
        country_slugs.each do |country_slug|
          current_country = Country.find_by(slug: country_slug)
          region.countries << current_country unless current_country.nil?
        end
      end

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
