# frozen_string_literal: true

module Mutations
  class UpdateOrganizationCertifications < Mutations::BaseMutation
    argument :product_slugs, [String], required: true
    argument :slug, String, required: true

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(product_slugs: [], slug:)
      organization = Organization.find_by(slug:)

      unless an_admin || an_org_owner(organization.id)
        return {
          organization: nil,
          errors: ['Must be admin or organization owner to update an organization']
        }
      end

      organization.certifications = []
      if !product_slugs.nil? && !product_slugs.empty?
        product_slugs.each do |product_slug|
          product = Product.find_by(slug: product_slug)
          organization.certifications << product.id.to_s unless product.nil?
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
