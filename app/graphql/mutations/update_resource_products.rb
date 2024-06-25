# frozen_string_literal: true

module Mutations
  class UpdateResourceProducts < Mutations::BaseMutation
    argument :product_slugs, [String], required: true
    argument :slug, String, required: true

    field :resource, Types::ResourceType, null: true
    field :errors, [String], null: true

    def resolve(product_slugs:, slug:)
      resource = Resource.find_by(slug:)

      unless an_admin || a_content_editor
        return {
          resource: nil,
          errors: ['Must have proper rights to update a resource']
        }
      end

      resource.products = []
      if !product_slugs.nil? && !product_slugs.empty?
        product_slugs.each do |product_slug|
          current_product = Product.find_by(slug: product_slug)
          resource.products << current_product unless current_product.nil?
        end
      end

      if resource.save
        # Successful creation, return the created object with no errors
        {
          resource:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          resource: nil,
          errors: resource.errors.full_messages
        }
      end
    end
  end
end
