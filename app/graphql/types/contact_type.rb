# frozen_string_literal: true

module Types
  class ContactType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :email, String, null: false
    field :title, String, null: true
    field :main_contact, Boolean, null: false

    field :source, String, null: false
    field :biography, String, null: true
    field :image_file, String, null: false
    field :social_networking_services, GraphQL::Types::JSON, null: true

    field :organizations, [Types::OrganizationType], null: false
  end
end
