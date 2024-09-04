# frozen_string_literal: true

require 'modules/maturity_sync'
require 'yaml'

module Mutations
  class UpdateProductIndicators < Mutations::BaseMutation
    include Modules::MaturitySync

    argument :indicators_data, [GraphQL::Types::JSON], required: true
    argument :slug, String, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true

    def resolve(indicators_data:, slug:)
      unless an_admin
        return {
          product: nil,
          errors: ['Must be admin to update a product']
        }
      end

      product = Product.find_by(slug: slug)
      return { product: nil, errors: ["Product with slug '#{slug}' not found."] } if product.nil?

      errors = []
      indicator_config = YAML.load_file('config/indicator_config.yml')

      indicators_data.each do |indicator_data|
        category_indicator = CategoryIndicator.find_by(slug: indicator_data['category_indicator_slug'])

        if category_indicator.nil?
          errors << "CategoryIndicator with slug '#{indicator_data['category_indicator_slug']}' not found."
          next
        end

        product_indicator = ProductIndicator.find_or_initialize_by(
          category_indicator_id: category_indicator.id,
          product_id: product.id
        )

        if indicator_data['value'].nil?
          product_indicator.destroy!
        else
          converted_value = convert_raw_value(indicator_data['value'], category_indicator.name, category_indicator.rubric_category.name, indicator_config)
          product_indicator.indicator_value = converted_value
          product_indicator.save!
        end
      end

      if errors.any?
        return { product: nil, errors: errors }
      end

      if product.save
        calculate_maturity_scores(product.id)
        { product: Product.find_by(id: product.id), errors: [] }
      else
        { product: nil, errors: product.errors.full_messages }
      end
    end

    private

    def convert_raw_value(value, indicator_name, category_name, config)
      legacy_values = %w[low medium high t f]
      return value if legacy_values.include?(value)

      indicator_config = read_indicator_config(config, category_name, indicator_name)
      return 'N/A' if indicator_config.key?(:error)

      indicator_config.each do |scale, conditions|
        return scale.to_s if conditions.all? { |condition| evaluate_condition(value.to_f, condition) }
      end

      'N/A'
    end

    def read_indicator_config(config, category_name, indicator_name)
      config.each do |category|
        next unless category['category'] == category_name

        category['indicators'].each do |indicator|
          return {
            low: indicator['low'],
            medium: indicator['medium'],
            high: indicator['high']
          } if indicator['name'] == indicator_name
        end
      end

      { error: 'Indicator not found' }
    end

    def evaluate_condition(value, condition)
      condition_value = condition['value'].to_f

      case condition['operator']
      when 'greaterThan'
        value > condition_value
      when 'lessThan'
        value < condition_value
      when 'equalTo'
        value == condition_value
      else
        false
      end
    end
  end
end
