# frozen_string_literal: true

module Types
  class ProductIndicatorType < Types::BaseObject
    field :id, ID, null: false
    field :product_id, ID, null: false
    field :category_indicator_id, ID, null: false
    field :indicator_value, String, null: false

    field :category_indicator, Types::CategoryIndicatorType, null: false
  end
end
