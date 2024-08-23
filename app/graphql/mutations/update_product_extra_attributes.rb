# frozen_string_literal: true

module Mutations
  class UpdateProductExtraAttributes < Mutations::BaseMutation
    argument :slug, String, required: true
    argument :local_ownership, String, required: false
    argument :impact, String, required: false
    argument :years_in_production, String, required: false

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true
    field :message, String, null: true

    def resolve(slug:, local_ownership: nil, impact: nil, years_in_production: nil)
      product = Product.find_by(slug:)

      unless an_admin || a_product_owner(product)
        return {
          product: nil,
          errors: ['Must be admin or product owner to update product attributes.']
        }
      end

      if product.nil?
        return {
          product: nil,
          errors: ['Product not found.']
        }
      end

      product.local_ownership = local_ownership if local_ownership.present?
      product.impact = impact if impact.present?
      product.years_in_production = years_in_production if years_in_production.present?

      if product.save
        {
          product:,
          errors: [],
          message: 'Product extra attributes updated successfully'
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
