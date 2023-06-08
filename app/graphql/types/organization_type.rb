# frozen_string_literal: true

module Types
  class OrganizationDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :organization_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class OfficeType < Types::BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :latitude, String, null: false
    field :longitude, String, null: false
    field :city, String, null: false
    field :organization_id, Integer, null: false
    field :country, Types::CountryType, null: false, method: :office_country
    field :region, String, null: false, method: :office_region
  end

  class OrganizationType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :image_file, String, null: true
    field :website, String, null: true

    field :is_mni, Boolean, null: true
    field :is_endorser, Boolean, null: true
    field :when_endorsed, GraphQL::Types::ISO8601Date, null: true
    field :endorser_level, String, null: true

    field :organization_descriptions, [Types::OrganizationDescriptionType], null: true

    field :sectors, [Types::SectorType], null: true, method: :sectors_localized
    field :organization_description, Types::OrganizationDescriptionType, null: true,
                                                                         method: :organization_description_localized

    field :countries, [Types::CountryType], null: true, method: :organization_countries_ordered
    field :offices, [Types::OfficeType], null: true
    field :projects, [Types::ProjectType], null: false
    field :products, [Types::ProductType], null: false
    field :contacts, [Types::ContactType], null: true

    def contacts
      an_admin = context[:current_user]&.roles&.include?('admin')
      an_organization_owner = context[:current_user]&.organization_id&.equal?(object&.id)

      organizations_contacts = []
      if an_admin || an_organization_owner
        object.contacts.each do |contact|
          current_contact = contact.as_json

          organization_contact = OrganizationsContact.where(ended_at: nil)
          organization_contact = organization_contact.where(organization_id: object.id)
          organization_contact = organization_contact.where(contact_id: contact.id)
          organization_contact = organization_contact.order(started_at: :desc)
          organization_contact = organization_contact.first

          current_contact['main_contact'] = organization_contact&.main_contact

          organizations_contacts << current_contact
        end
      end
      organizations_contacts
    end

    field :specialties, [String], null: false
    field :resources, [Types::ResourceType], null: true
    field :aliases, GraphQL::Types::JSON, null: true
  end
end
