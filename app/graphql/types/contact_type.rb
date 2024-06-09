# frozen_string_literal: true

module Types
  class ContactType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :title, String, null: true

    field :slug, String, null: false
    field :email, String, null: true
    def email
      return nil if context[:current_user].nil?
      object.email
    end

    field :main_contact, Boolean, null: false

    field :source, String, null: false
    field :biography, String, null: true
    field :image_file, String, null: false

    field :social_networking_services, GraphQL::Types::JSON, null: true
    def social_networking_services
      return [] if context[:current_user].nil?
      object.social_networking_services
    end

    field :extended_data, GraphQL::Types::JSON, null: true
    def extended_data
      return [] if context[:current_user].nil?
      object.extended_data
    end

    field :organizations, [Types::OrganizationType], null: false
  end
end
