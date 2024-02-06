# frozen_string_literal: true

module Mutations
  class UpdateProductResources < Mutations::BaseMutation
    argument :resource_slugs, [String], required: true
    argument :slug, String, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true

    def resolve(resource_slugs:, slug:)
      product = Product.find_by(slug:)

      unless an_admin || a_product_owner(product.id)
        return {
          product: nil,
          errors: ['Must be admin or product owner to update a product']
        }
      end

      product.resources = []
      if !resource_slugs.nil? && !resource_slugs.empty?
        resource_slugs.each do |resource_slug|
          current_resource = Resource.find_by(slug: resource_slug)
          product.resources << current_resource unless current_resource.nil?
        end
      end

      if product.save
        # Successful creation, return the created object with no errors
        {
          product:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          product: nil,
          errors: product.errors.full_messages
        }
      end
    end
  end
end
