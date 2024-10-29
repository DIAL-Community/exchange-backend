# frozen_string_literal: true

module Mutations
  class UpdateProductBuildingBlocks < Mutations::BaseMutation
    argument :building_block_slugs, [String], required: true
    argument :mapping_status, String, required: false
    argument :slug, String, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true

    def resolve(building_block_slugs:, mapping_status:, slug:)
      product = Product.find_by(slug:)
      product_policy = Pundit.policy(context[:current_user], product || Product.new)
      if product.nil? || !product_policy.edit_allowed?
        return {
          product: nil,
          errors: ['Editing product is not allowed.']
        }
      end

      product.building_blocks = []
      if !building_block_slugs.nil? && !building_block_slugs.empty?
        building_block_slugs.each do |building_block_slug|
          current_building_block = BuildingBlock.find_by(slug: building_block_slug)
          product.building_blocks << current_building_block unless current_building_block.nil?
          # For every building block assign the mapping status
          current_product_building_block = ProductBuildingBlock.find_by(slug: "#{slug}_#{building_block_slug}")
          unless current_product_building_block.nil?
            current_product_building_block.mapping_status = mapping_status
            current_product_building_block.save
          end
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
