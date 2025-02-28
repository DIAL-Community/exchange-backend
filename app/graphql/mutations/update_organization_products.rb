# frozen_string_literal: true

module Mutations
  class UpdateOrganizationProducts < Mutations::BaseMutation
    argument :product_slugs, [String], required: true
    argument :slug, String, required: true

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(product_slugs:, slug:)
      organization = Organization.find_by(slug:)
      organization_policy = Pundit.policy(context[:current_user], organization || Organization.new)
      if organization.nil? || !organization_policy.edit_allowed?
        return {
          organization: nil,
          errors: ['Editing organization is not allowed.']
        }
      end

      organization.products = []
      if !product_slugs.nil? && !product_slugs.empty?
        product_slugs.each do |product_slug|
          current_product = Product.find_by(slug: product_slug)
          unless current_product.nil?
            organization.products << current_product
          end
        end
      end

      if organization.save
        # Successful creation, return the created object with no errors
        {
          organization:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          organization: nil,
          errors: organization.errors.full_messages
        }
      end
    end
  end
end
