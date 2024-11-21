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
      product_policy = Pundit.policy(context[:current_user], product || Product.new)
      if product.nil? || !product_policy.edit_allowed?
        return {
          product: nil,
          errors: ['Editing product is not allowed.']
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
