# frozen_string_literal: true

module Types
  class DigitalPrincipleType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :url, String, null: false
    field :phase, String, null: false
  end

  class WizardType < Types::BaseObject
    field :resources, [Types::ResourceType], null: false
    field :playbooks, [Types::PlaybookType], null: false

    field :digital_principles, [Types::DigitalPrincipleType], null: false
  end
end
