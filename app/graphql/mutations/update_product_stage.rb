# frozen_string_literal: true

module Mutations
  class UpdateProductStage < Mutations::BaseMutation
    argument :slug, String, required: true
    argument :product_stage, String, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true
    field :message, String, null: true

    def resolve(slug:, product_stage:)
      product = Product.find_by(slug:)

      unless an_admin
        return {
          product: nil,
          errors: ['Must be admin to update a product stage.']
        }
      end

      if product.nil?
        return {
          product: nil,
          errors: ['Product not found.']
        }
      end

      if Product::STAGES.include?(product_stage)
        product.product_stage = product_stage
      else
        return {
          product: nil,
          errors: ['Invalid product stage']
        }
      end

      if product.save
        {
          product:,
          errors: [],
          message: 'Product stage updated successfully'
        }
      else
        {
          product: nil,
          errors: product.errors.full_messages
        }
      end
    end
  end
end
