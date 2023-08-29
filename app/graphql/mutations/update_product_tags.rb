# frozen_string_literal: true

module Mutations
  class UpdateProductTags < Mutations::BaseMutation
    argument :tag_names, [String], required: true
    argument :slug, String, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true

    def resolve(tag_names:, slug:)
      product = Product.find_by(slug:)

      unless an_admin || a_product_owner(product.id)
        return {
          product: nil,
          errors: ['Must be admin or product owner to update a product']
        }
      end

      product.tags = []
      if !tag_names.nil? && !tag_names.empty?
        tag_names.each do |tag_name|
          tag = Tag.find_by(name: tag_name)
          product.tags << tag.name unless tag.nil?
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
