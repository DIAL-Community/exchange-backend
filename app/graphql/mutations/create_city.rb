# frozen_string_literal: true

require 'modules/slugger'
require 'modules/geocode'

module Mutations
  class CreateCity < Mutations::BaseMutation
    include Modules::Slugger
    include Modules::Geocode

    argument :slug, String, required: false
    argument :city_name, String, required: true
    argument :province_name, String, required: true
    argument :country_name, String, required: true

    field :city, Types::CityType, null: true
    field :errors, [String], null: true

    def resolve(city_name:, province_name:, country_name:, slug:)
      # Find the correct policy
      city = City.find_by(slug:)
      city = City.find_by(name: city_name) if city.nil?
      city_policy = Pundit.policy(context[:current_user], city || City.new)

      if city.nil? && !city_policy.create_allowed?
        return {
          city: nil,
          errors: ['Creating / editing city is not allowed.']
        }
      end

      if !city.nil? && !city_policy.edit_allowed?
        return {
          city: nil,
          errors: ['Creating / editing city is not allowed.']
        }
      end

      country = Country.find_by(name: country_name)

      return {
        city: nil,
        errors: ['Unable to resolve country name.']
      } if country.nil?

      province = Province.find_by(name: province_name)
      province = find_province(
        province_name,
        country.code,
        Rails.application.secrets.google_api_key
      ) if province.nil?

      return {
        city: nil,
        errors: ['Unable to resolve province name.']
      } if province.nil?

      city = find_city(
        city_name,
        province.name,
        country.code,
        Rails.application.secrets.google_api_key
      ) if city.nil?

      successful_operation = !city.nil?
      if successful_operation
        # Successful creation, return the created object with no errors
        {
          city:,
          errors: []
        }
      else
        # Failed save, return the errors to the client.
        # We will only reach this block if the transaction is failed.
        {
          city: nil,
          errors: city.errors.full_messages
        }
      end
    end
  end
end
