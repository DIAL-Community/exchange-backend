# frozen_string_literal: true

module Mutations
  class DeleteProduct < Mutations::BaseMutation
    argument :id, ID, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      product = Product.find_by(id:)
      product_policy = Pundit.policy(context[:current_user], product || Product.new)
      if product.nil? || !product_policy.delete_allowed?
        return {
          product: nil,
          errors: ['Deleting product is not allowed.']
        }
      end

      # Delete any candidate roles that reference this product

      successful_operation = false
      ActiveRecord::Base.transaction do
        candidate_roles = CandidateRole.where(product_id: id).destroy_all
        puts "Deleted #{candidate_roles.count} candidate roles."

        assign_auditable_user(product)
        product.destroy!

        successful_operation = true
      end

      if successful_operation
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
