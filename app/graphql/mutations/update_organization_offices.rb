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
        office_params = generate_office_params(office)
        current_office = Office.find_by(
          organization_id: organization.id,
          city: office_params[:city],
          province_id: office_params[:province_id],
          country_id: office_params[:country_id]
        )
        if current_office.nil?
          current_office = Office.new(office_params)
          current_office.organization_id = organization.id
        else
          current_office.update(office_params)
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

    def generate_office_params(office)
      city = find_city(
        office['cityName'],
        office['regionName'],
        office['countryCode'],
        Rails.application.secrets.google_api_key
      )

      province = city.province
      country = province.country

      name_string = "#{city.name}, #{province.name}, #{country.code}"
      office_params = {
        name: name_string,
        slug: reslug_em(name_string),

        province_id: province.id,
        country_id: country.id,

        city: city.name,
        latitude: city.latitude,
        longitude: city.longitude

      }
      office_params
    end
  end
end
