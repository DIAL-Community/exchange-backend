# frozen_string_literal: true

module Mutations
  class UpdateProductCategories < Mutations::BaseMutation
    argument :category_slugs, [String], required: true
    argument :feature_slugs, [String], required: true
    argument :slug, String, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true

    def resolve(category_slugs:, feature_slugs:, slug:)
      product = Product.find_by(slug:)
      product_policy = Pundit.policy(context[:current_user], product || Product.new)
      if product.nil? || !product_policy.edit_allowed?
        return {
          product: nil,
          errors: ['Editing product is not allowed.']
        }
      end

      product.software_categories = []
      if !category_slugs.nil? && !category_slugs.empty?
        category_slugs.each do |category_slug|
          current_category = SoftwareCategory.where("slug in (?)", category_slug)
          product.software_categories << current_category unless current_category.nil?
        end
      end

      product.software_features = []
      if !feature_slugs.nil? && !feature_slugs.empty?
        feature_slugs.each do |feature_slug|
          current_feature = SoftwareFeature.where("slug in (?)", feature_slug)
          product.software_features << current_feature unless current_feature.nil?
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
