# frozen_string_literal: true

module Types
  class ResourceType < Types::BaseObject
    field :name, String, null: false
    field :slug, String, null: false
    field :phase, String, null: false

    field :link, String, null: true
    field :image_url, String, null: true
    field :description, String, null: true

    field :show_in_exchange, Boolean, null: false
    field :show_in_wizard, Boolean, null: false
  end
end
