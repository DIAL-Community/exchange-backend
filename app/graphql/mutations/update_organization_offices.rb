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
      organization_policy = Pundit.policy(context[:current_user], organization || Organization.new)
      if organization.nil? || !organization_policy.edit_allowed?
        return {
          organization: nil,
          errors: ['Editing organization is not allowed.']
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
          current_office.save
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
      # Note, that we are using 'regionName'. This is actually the province, but it is coming
      # from the geocoding as regionName

      country = Country.find_by(
        'name = :param OR code = :param OR code_longer = :param OR :param = ANY(aliases)',
        param: office['countryCode']
      )

      province = Province.find_by(
        '(name = :province_param OR :province_param = ANY(aliases)) AND country_id = :country_param',
        province_param: office['regionName'],
        country_param: country.id
      ) unless country.nil?

      if province.nil? && !country.nil?
        province = Province.new
        province.name = office['regionName']
        province.slug = reslug_em(province.name)
        province.country_id = country.id unless country.nil?
        province.latitude = office['latitude']
        province.longitude = office['longitude']
        province.save!
      end

      name_string = "#{office['cityName']}, #{office['regionName']}, #{office['countryCode']}"
      office_params = {
        name: name_string,
        slug: reslug_em(name_string),

        province_id: province&.id,
        country_id: country&.id,

        city: office['cityName'],
        latitude: office['latitude'],
        longitude: office['longitude']

      }
      office_params
    end
  end
end
