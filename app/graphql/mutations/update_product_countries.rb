# frozen_string_literal: true

module Mutations
  class UpdateProductCountries < Mutations::BaseMutation
    argument :country_slugs, [String], required: true
    argument :slug, String, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true

    def resolve(country_slugs:, slug:)
      product = Product.find_by(slug:)

      unless an_admin || product_owner(product)
        return {
          product: nil,
          errors: ['Must have proper rights to update a product']
        }
      end

      product.countries = []
      if !country_slugs.nil? && !country_slugs.empty?
        country_slugs.each do |country_slug|
          current_country = Country.find_by(slug: country_slug)
          product.countries << current_country unless current_country.nil?
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
