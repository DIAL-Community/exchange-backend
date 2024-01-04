# frozen_string_literal: true

module Types
  class AuthorType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :email, String, null: false
    field :picture, String, null: false
  end

  class ResourceType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :phase, String, null: false

    field :image_file, String, null: false
    field :image_url, String, null: true

    field :description, String, null: true
    field :parsed_description, String, null: true
    def parsed_description
      first_paragraph = Nokogiri::HTML.fragment(object.description).at('p')
      return first_paragraph.text unless first_paragraph.nil?
      object.description if first_paragraph.nil?
    end

    field :show_in_exchange, Boolean, null: false
    field :show_in_wizard, Boolean, null: false

    field :link_description, String, null: true
    field :resource_file, String, null: true
    field :resource_link, String, null: true

    field :resource_type, String, null: true
    field :resource_topic, String, null: true
    field :source, String, null: true

    field :tags, GraphQL::Types::JSON, null: false

    field :featured, Boolean, null: false
    field :spotlight, Boolean, null: false

    field :published_date, GraphQL::Types::ISO8601Date, null: true

    field :organizations, [Types::OrganizationType], null: false
    field :countries, [Types::CountryType], null: false, method: :countries_ordered
    field :authors, [Types::AuthorType], null: false, method: :authors_ordered
  end
end
