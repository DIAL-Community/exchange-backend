# frozen_string_literal: true

module Types
  class TagDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :tag_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class TagType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :tag_descriptions, [Types::TagDescriptionType], null: true
    field :tag_description, Types::TagDescriptionType, null: true, method: :tag_description_localized

    field :datasets, [Types::DatasetType], null: false
    field :products, [Types::ProductType], null: false
    field :projects, [Types::ProjectType], null: false
    field :use_cases, [Types::UseCaseType], null: false

    def datasets
      Dataset.where(
        "tags @> '{#{object.name.downcase}}'::varchar[] or " \
        "tags @> '{#{object.name}}'::varchar[]"
      )
    end

    def products
      Product.where(
        "tags @> '{#{object.name.downcase}}'::varchar[] or " \
        "tags @> '{#{object.name}}'::varchar[]"
      )
    end

    def projects
      Project.where(
        "tags @> '{#{object.name.downcase}}'::varchar[] or " \
        "tags @> '{#{object.name}}'::varchar[]"
      )
    end

    def use_cases
      UseCase.where(
        "tags @> '{#{object.name.downcase}}'::varchar[] or " \
        "tags @> '{#{object.name}}'::varchar[]"
      )
    end
  end
end
