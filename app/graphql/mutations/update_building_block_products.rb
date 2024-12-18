# frozen_string_literal: true

module Mutations
  class UpdateBuildingBlockProducts < Mutations::BaseMutation
    argument :slug, String, required: true
    argument :product_slugs, [String], required: true
    argument :mapping_status, String, required: true

    field :building_block, Types::BuildingBlockType, null: true
    field :errors, [String], null: true

    def resolve(slug:, product_slugs:, mapping_status:)
      building_block = BuildingBlock.find_by(slug:) unless slug.blank?
      building_block_policy = Pundit.policy(context[:current_user], building_block || BuildingBlock.new)
      unless building_block_policy.edit_allowed?
        return {
          building_block: nil,
          errors: ['Editing building block is not allowed.']
        }
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        building_block.product_building_blocks = []
        product_slugs&.each do |product_slug|
          product = Product.find_by(slug: product_slug)
          current_building_block_product = ProductBuildingBlock.find_by(building_block:, product:)
          if current_building_block_product.nil?
            current_building_block_product = ProductBuildingBlock.new(building_block:, product:)
          end
          current_building_block_product.mapping_status = mapping_status
          building_block.product_building_blocks << current_building_block_product
        end

        building_block.save!
        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          building_block:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          building_block: nil,
          errors: building_block.errors.full_messages
        }
      end
    end
  end
end
