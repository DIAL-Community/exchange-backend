# frozen_string_literal: true

module Mutations
  class DeleteProduct < Mutations::BaseMutation
    argument :id, ID, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          product: nil,
          errors: ['Must be admin to delete a product.']
        }
      end

      product = Product.find_by(id:)
      assign_auditable_user(product)
      if product.destroy
        # Successful deletion, return the deleted product with no errors
        {
          product:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          product: nil,
          errors: product.errors.full_messages
        }
      end
    end
  end
end
