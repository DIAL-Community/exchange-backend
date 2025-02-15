# frozen_string_literal: true

module Types
  class BuildingBlockDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :building_block_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class BuildingBlockType < Types::BaseObject
    include ActionView::Helpers::SanitizeHelper

    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :image_file, String, null: false

    field :maturity, String, null: true
    field :category, String, null: true
    field :spec_url, String, null: true

    field :gov_stack_entity, Boolean, null: false

    field :building_block_descriptions, [Types::BuildingBlockDescriptionType], null: true
    field :building_block_description, Types::BuildingBlockDescriptionType, null: true,
          method: :building_block_description_localized

    # First paragraph of the building block description
    field :parsed_description, String, null: true
    def parsed_description
      return if object.building_block_description_localized.nil?

      object_description = object.building_block_description_localized.description
      strip_links(object_description)
    end

    field :workflows, [Types::WorkflowType], null: true
    field :products, [Types::ProductType], null: true
  end
end
