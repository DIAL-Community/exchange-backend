# frozen_string_literal: true

module Mutations
  class UpdateCandidateProductExtraAttributes < Mutations::BaseMutation
    argument :slug, String, required: true
    argument :extra_attributes, [Attributes::ExtraAttribute], required: true

    field :candidate_product, Types::CandidateProductType, null: true
    field :errors, [String], null: true

    def resolve(slug:, extra_attributes:)
      candidate_product = CandidateProduct.find_by(slug:)
      candidate_product_policy = Pundit.policy(context[:current_user], candidate_product || CandidateProduct.new)
      if candidate_product.nil? || candidate_product_policy.edit_allowed?
        return {
          candidate_product: nil,
          errors: ['Editing candidate product is not allowed.']
        }
      end

      extra_attributes.each do |attr|
        candidate_product.update_extra_attributes(name: attr[:name], value: attr[:value], type: attr[:type])
      end

      if candidate_product.save
        {
          candidate_product:,
          errors: []
        }
      else
        {
          candidate_product: nil,
          errors: candidate_product.errors.full_messages
        }
      end
    end
  end
end
