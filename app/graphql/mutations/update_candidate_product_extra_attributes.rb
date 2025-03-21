# frozen_string_literal: true

module Mutations
  class UpdateCandidateProductExtraAttributes < Mutations::BaseMutation
    argument :slug, String, required: true
    argument :extra_attributes, [Attributes::ExtraAttribute], required: true

    field :errors, [String], null: true
    field :product, Types::ProductType, null: true
    field :candidate_product, Types::CandidateProductType, null: true

    def resolve(slug:, extra_attributes:)
      candidate_product = CandidateProduct.find_by(slug:)
      candidate_product_policy = Pundit.policy(context[:current_user], candidate_product || CandidateProduct.new)
      if candidate_product_policy.edit_allowed?
        extra_attributes.each do |attr|
          candidate_product&.update_extra_attributes(
            # Pass the required fields for the extra attribute entry.
            name: attr[:name],
            value: attr[:value],
            # Pass the optional fields for the extra attribute entry.
            type: attr[:type],
            index: attr[:index],
            title: attr[:title],
            description: attr[:description]
          )
        end
      end

      product = Product.find_by(slug:)
      product_policy = Pundit.policy(context[:current_user], product || Product.new)
      if product_policy.edit_allowed?
        extra_attributes.each do |attr|
          product&.update_extra_attributes(
            # Pass the required fields for the extra attribute entry.
            name: attr[:name],
            value: attr[:value],
            # Pass the optional fields for the extra attribute entry.
            type: attr[:type],
            index: attr[:index],
            title: attr[:title],
            description: attr[:description]
          )
        end
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        product&.save
        candidate_product&.save
        successful_operation = true
      end

      if successful_operation
        {
          product:,
          candidate_product:,
          errors: []
        }
      else
        {
          product: nil,
          candidate_product: nil,
          errors: candidate_product.errors.full_messages
        }
      end
    end
  end
end
