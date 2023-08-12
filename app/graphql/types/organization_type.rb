# frozen_string_literal: true

module Types
  class OrganizationDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :organization_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
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

    field :have_owner, Boolean, null: false
    def have_owner
      !User.find_by('? = organization_id', object&.id).nil?
    end

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

    field :certifications, [String], null: false
    field :product_certifications, [Types::ProductType], null: false
    def product_certifications
      Product.where(id: object.certifications)
    end

    field :building_blocks, [String], null: false
    field :building_block_certifications, [Types::BuildingBlockType], null: false
    def building_block_certifications
      BuildingBlock.where(id: object.building_blocks)
    end

    field :resources, [Types::ResourceType], null: true
    field :aliases, GraphQL::Types::JSON, null: true

    field :hero_file, String, null: true
    field :has_storefront, Boolean, null: true
  end
end
