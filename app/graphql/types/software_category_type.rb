# frozen_string_literal: true

module Types
  class SoftwareCategoryType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :description, String, null: false

    field :software_features, [Types::SoftwareFeatureType], null: false
  end
end
