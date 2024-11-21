# frozen_string_literal: true

module Mutations
  class UpdateProductOrganizations < Mutations::BaseMutation
    argument :organization_slugs, [String], required: true
    argument :slug, String, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true

    def resolve(organization_slugs:, slug:)
      product = Product.find_by(slug:)
      product_policy = Pundit.policy(context[:current_user], product || Product.new)
      if product.nil? || !product_policy.edit_allowed?
        return {
          product: nil,
          errors: ['Editing product is not allowed.']
        }
      end

      product.organizations = []
      if !organization_slugs.nil? && !organization_slugs.empty?
        organization_slugs.each do |organization_slug|
          current_organization = Organization.find_by(slug: organization_slug)
          product.organizations << current_organization unless current_organization.nil?
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
