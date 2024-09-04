# frozen_string_literal: true

module Mutations
  class UpdateProductExtraAttributes < Mutations::BaseMutation
    argument :slug, String, required: true
    argument :extra_attributes, [Types::ExtraAttributeInputType], required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true
    field :message, String, null: true

    def resolve(slug:, extra_attributes:)
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

      extra_attributes.each do |attr|
        product.set_extra_attribute(name: attr[:name], value: attr[:value], type: attr[:type])
      end

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
