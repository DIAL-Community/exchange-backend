# frozen_string_literal: true

module Mutations
  class DeleteProductRepository < Mutations::BaseMutation
    argument :id, ID, required: true

    field :product_repository, Types::ProductRepositoryType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      product_repository = ProductRepository.find_by(id:)
      product = product_repository.product
      if product_repository.nil? || product.nil? \
        || !a_product_owner(product.id) || !an_admin
        return {
          product_repository: nil,
          errors: ['Unable to delete the product repository object.']
        }
      end

      assign_auditable_user(product_repository)
      if product_repository.destroy
        # Successful deletion, return the deleted product_repository with no errors
        {
          product_repository:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          product_repository: nil,
          errors: product_repository.errors.full_messages
        }
      end
    end
  end
end
