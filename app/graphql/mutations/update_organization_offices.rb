# frozen_string_literal: true

require 'modules/slugger'
require 'modules/geocode'

module Mutations
  class UpdateOrganizationOffices < Mutations::BaseMutation
    include Modules::Slugger
    include Modules::Geocode

    argument :offices, [GraphQL::Types::JSON], required: true
    argument :slug, String, required: true

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(offices:, slug:)
      organization = Organization.find_by(slug:)

      unless an_admin || an_org_owner(organization.id)
        return {
          organization: nil,
          errors: ['Must be admin or organization owner to update an organization']
        }
      end

      organization.offices = []
      offices&.each do |office|
        slug_string = "#{organization.name} #{office['cityName']} #{office['regionName']} #{office['countryCode']}"
        office_slug = slug_em(slug_string)
        current_office = Office.find_by(slug: office_slug)
        if current_office.nil?
          current_office = create_new_office(office, office_slug)
          current_office.organization_id = organization.id
        end
        organization.offices << current_office
      end

      if organization.save
        # Successful creation, return the created object with no errors
        {
          organization:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          organization: nil,
          errors: organization.errors.full_messages
        }
      end
    end

    def create_new_office(office, office_slug)
      name_string = office['cityName'] + ", " + office['regionName'] + ", " + office['countryCode']
      new_office = Office.new(name: name_string, slug: office_slug)

      city = find_city(
        office['cityName'],
        office['regionName'],
        office['countryCode'],
        Rails.application.secrets.google_api_key
      )

      region = Region.find(city.region_id)
      country = Country.find(region.country_id)

      new_office.country_id = country.id
      new_office.region_id = region.id

      new_office.city = city.name
      new_office.latitude = city.latitude
      new_office.longitude = city.longitude
      new_office
    end
  end
end
