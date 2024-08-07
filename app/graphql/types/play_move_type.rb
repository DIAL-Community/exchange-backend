# frozen_string_literal: true

module Types
  class PlayMoveDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :move_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class PlayMoveType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :move_order, Integer, null: true

    field :resources, [ResourceType], null: true
    field :inline_resources, GraphQL::Types::JSON, null: false

    field :move_descriptions, [Types::PlayMoveDescriptionType], null: true
    field :move_description, Types::PlayMoveDescriptionType, null: true,
                                                                  method: :play_move_description_localized

    field :play, Types::PlayType, null: false
    field :play_name, String, null: true
    field :play_slug, String, null: true
  end
end
