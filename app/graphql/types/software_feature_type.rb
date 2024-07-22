# frozen_string_literal: true

module Types
  class SoftwareFeatureType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :description, String, null: false
    field :facility_scale, Integer, null: false
    field :category_id, Integer, null: false
    def category_id 
      object.software_category.id
    end

    field :software_category, Types::SoftwareCategoryType, null: false
  end
end