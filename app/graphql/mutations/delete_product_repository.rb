# frozen_string_literal: true

module Mutations
  class DeleteProductRepository < Mutations::BaseMutation
    argument :id, ID, required: true

    field :product_repository, Types::ProductRepositoryType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      product_repository = ProductRepository.find_by(id:)
      product = product_repository.product
      product_policy = Pundit.policy(context[:current_user], product || Product.new)
      if product_repository.nil? || !product_policy.delete_allowed?
        return {
          product_repository: nil,
          errors: ['Deleting product repository is not allowed.']
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
