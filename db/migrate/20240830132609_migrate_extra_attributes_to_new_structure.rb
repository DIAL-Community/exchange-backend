# frozen_string_literal: true
class MigrateExtraAttributesToNewStructure < ActiveRecord::Migration[6.1]
  def up
    Product.find_each do |product|
      next unless product.extra_attributes.is_a?(Hash)

      new_extra_attributes = []

      product.extra_attributes.each do |key, value|
        new_extra_attributes << { 'name' => key, 'value' => value }
      end

      product.update(extra_attributes: new_extra_attributes)
    end
  end

  def down
    Product.find_each do |product|
      next unless product.extra_attributes.is_a?(Array)

      old_extra_attributes = {}

      product.extra_attributes.each do |attribute|
        old_extra_attributes[attribute['name']] = attribute['value']
      end

      product.update(extra_attributes: old_extra_attributes)
    end
  end
end
