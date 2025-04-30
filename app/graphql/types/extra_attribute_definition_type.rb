# frozen_string_literal: true

module Types
  class ExtraAttributeDefinitionType < Types::BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false

    field :attribute_type, String, null: false
    field :attribute_required, Boolean, null: false

    field :title, String, null: false
    field :title_fallback, String, null: true

    field :description, String, null: false
    field :description_fallback, String, null: true

    field :entity_types, [String], null: false

    field :choices, [String], null: false
    field :multiple_choice, Boolean, null: false
  end
end
