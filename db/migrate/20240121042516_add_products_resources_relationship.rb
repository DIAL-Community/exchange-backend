# frozen_string_literal: true

class AddProductsResourcesRelationship < ActiveRecord::Migration[7.0]
  def change
    create_join_table(:products, :resources, table_name: 'products_resources') do |t|
      t.index(:product_id)
      t.index(:resource_id)
    end
  end
end
