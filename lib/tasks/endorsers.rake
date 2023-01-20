# frozen_string_literal: true

require 'modules/geocode'
require 'modules/slugger'
require 'modules/google_apis'

include Modules::Geocode
include Modules::Slugger
include Modules::GoogleApis

namespace :endorsers do
  # Structure of the form's spreadsheet:
  # - Timestamp
  # - Email Address
  # - Name
  # - Role / Title
  # - Organization's Name
  # - Organization's Website
  # - Organization Type
  # - Headquarters - City
  # - Headquarters - Country
  # - Countries
  # - Sectors
  # - Sustainable Development Goals
  # - Organization Goals & Activities
  # - Contact Person
  # - Contact Person's Name
  # - Contact Person's Title
  # - Email Address
  # - Relationships
  # - Organization Logo
  # - Consent
  # - Feedback Question
  # - Additional Feedback
  # - Column Z: Approval Marker.
  MAX_COLUMN_COUNT = 26

  desc 'Read and parse endorser data from the form response.'
  task sync_form_response: :environment do |_, _params|
    spreadsheet_id = '1wFAs-HeamUIwRwKCKwJqOmaWvXBwHoBQSSx6dctWn-Y'
    range = 'Form Responses!A2:Z'
    response = read_spreadsheet(spreadsheet_id, range)

    puts 'No data found.' if response.values.empty?

    response.values.each do |row|
      approved_as_endorser = row[MAX_COLUMN_COUNT - 1].to_s == 'Y'
      next unless approved_as_endorser

      _timestamp, email_address, name, title, organization_name, organization_website, _organization_type,
      headquarters_city, headquarters_country, countries, sectors, _sdgs, _organizations_goals, contact_person,
      contact_name, contact_title, contact_email = row

      organization_slug = slug_em(organization_name)
      organization = Organization.find_by(slug: organization_slug)
      if organization.nil?
        organization = Organization.new(name: organization_name, slug: organization_slug)
        if Organization.where(slug: organization.slug).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Organization.slug_simple_starts_with(organization.slug)
                                        .order(slug: :desc).first
          organization.slug = organization.slug + generate_offset(first_duplicate)
        end
      end

      organization.name = organization_name
      organization.website = organization_website

      organization.is_endorser = true
      organization.when_endorsed = Time.utc(Time.now.utc.year, Time.now.utc.month, Time.now.utc.day)

      # Let the default value. Adding it here to show we have this field in the organization table.
      # organization.endorser_level = 'none'

      if contact_person.to_s == 'Yes'
        existing_contact = Contact.find_by(name: name, email: email_address)
        existing_contact = Contact.new(name: name, email: email_address, title: title) if existing_contact.nil?
      else
        existing_contact = Contact.find_by(name: contact_name, email: contact_email)
        existing_contact = Contact.new(name: contact_name, email: contact_email, title: contact_title) \
          if existing_contact.nil?
      end
      existing_contact.slug = slug_em(existing_contact.name)
      organization.contacts << existing_contact

      assigned_sectors = []
      Sector.all.each do |sector|
        assigned_sectors << sector if sectors.include?(sector.name)
      end
      organization.sectors = assigned_sectors

      assigned_countries = []
      countries.split(',').each do |country_name|
        country = Country.find_by(name: country_name.strip)
        assigned_countries << country unless country.nil?
      end
      organization.countries = assigned_countries

      existing_country = Country.find_by(name: headquarters_country)
      existing_city = City.find_by(name: headquarters_city)
      if existing_city.nil?
        google_auth_key = Rails.application.secrets.google_api_key
        existing_city = find_city(headquarters_city, headquarters_city, existing_country.code, google_auth_key)
      end

      if !existing_city.nil? && !existing_city.id.nil?
        existing_office_name = "#{organization.name} #{existing_city.name}"

        existing_region = Region.find(existing_city.region_id)
        existing_office_name = "#{existing_office_name} #{existing_region.name}" unless existing_region.nil?
        existing_office_name = "#{existing_office_name} #{existing_country.code}" unless existing_country.nil?

        existing_office = Office.find_by(slug: slug_em(existing_office_name))
        if existing_office.nil?
          existing_office = Office.new(name: existing_office_name, slug: slug_em(existing_office_name))
          existing_office.latitude = existing_city.latitude
          existing_office.longitude = existing_city.longitude
          existing_office.city = existing_city.name

          existing_office.country_id = existing_region.id unless existing_region.nil?
          existing_office.region_id = existing_country.id unless existing_country.nil?
        end

        organization.offices = [existing_office] unless existing_office.nil?
      end

      if organization.save!
        puts "Endorser '#{organization.name}' added to the database."
      end
    end
  end

  def generate_offset(first_duplicate)
    size = 0
    if !first_duplicate.nil? && first_duplicate.slug.include?('_dup')
      size = first_duplicate.slug
                            .slice(/_dup\d+$/)
                            .delete('^0-9')
                            .to_i + 1
    end
    "_dup#{size}"
  end
end
