# frozen_string_literal: true

module Types
  class ResourceType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :phase, String, null: false
    field :image_file, String, null: false

    field :link, String, null: true
    field :image_url, String, null: true
    field :description, String, null: true

    field :show_in_exchange, Boolean, null: false
    field :show_in_wizard, Boolean, null: false

    field :organizations, [Types::OrganizationType], null: true
  end
end
