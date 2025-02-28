# frozen_string_literal: true

require 'modules/maturity_sync'

module Mutations
  class UpdateProductIndicators < Mutations::BaseMutation
    include Modules::MaturitySync

    argument :indicators_data, [GraphQL::Types::JSON], required: true
    argument :slug, String, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true

    def resolve(indicators_data:, slug:)
      product = Product.find_by(slug:)
      product_policy = Pundit.policy(context[:current_user], product || Product.new)
      if product.nil? || !product_policy.edit_allowed?
        return {
          product: nil,
          errors: ['Editing product is not allowed.']
        }
      end

      indicators_data.each do |indicator_data|
        category_indicator = CategoryIndicator.find_by(slug: indicator_data['category_indicator_slug'])
        product_indicator = ProductIndicator.find_by(category_indicator_id: category_indicator.id,
                                                     product_id: product.id)
        if product_indicator.nil?
          product_indicator = ProductIndicator.new(category_indicator_id: category_indicator.id,
                                                   product_id: product.id)
        end

        if indicator_data['value'].nil?
          product_indicator.destroy!
        else
          product_indicator.indicator_value = indicator_data['value']
          product_indicator.save!
        end
      end

      if product.save
        calculate_maturity_scores(product.id)
        # Successful creation, return the created object with no errors
        # We need to refetch product from DB to get the calculated maturity scores
        {
          product: Product.find_by(id: product.id),
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
