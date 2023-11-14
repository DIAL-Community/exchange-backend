# frozen_string_literal: true

module Types
  class OpportunityType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :image_file, String, null: true
    field :description, String, null: false

    field :gov_stack_entity, Boolean, null: false

    field :parsed_description, String, null: true
    def parsed_description
      return if object.description.nil?

      object_description = object.description
      first_paragraph = Nokogiri::HTML.fragment(object_description).at('p')
      first_paragraph.nil? ? object_description : first_paragraph.inner_html
    end

    field :contact_name, String, null: true
    def contact_name
      context[:current_user].nil? ? nil : object.contact_name
    end

    field :contact_email, String, null: true
    def contact_email
      context[:current_user].nil? ? nil : object.contact_email
    end

    field :opening_date, GraphQL::Types::ISO8601Date, null: true
    field :closing_date, GraphQL::Types::ISO8601Date, null: true

    field :opportunity_type, String, null: false
    field :opportunity_status, String, null: false

    field :web_address, String, null: true
    field :requirements, String, null: true
    field :tags, GraphQL::Types::JSON, null: false

    field :sectors, [Types::SectorType], null: false, method: :sectors_localized
    field :countries, [Types::CountryType], null: false, method: :countries_ordered

    field :building_blocks, [Types::BuildingBlockType], null: false
    field :organizations, [Types::OrganizationType], null: false
    field :use_cases, [Types::UseCaseType], null: false

    field :origin, Types::OriginType, null: false
  end
end
