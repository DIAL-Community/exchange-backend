# frozen_string_literal: true
class AddExtraAttributesToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column(:products, :extra_attributes, :jsonb, default: {})

    create_table(:product_countries) do |t|
      t.bigint('product_id', null: false)
      t.bigint('country_id', null: false)
      t.index(%w[product_id country_id], name: 'product_countries_idx', unique: true)
      t.index(%w[country_id product_id], name: 'countries_product_idx', unique: true)
    end

    add_foreign_key('product_countries', 'countries', name: 'product_countries_country_fk')
    add_foreign_key('product_countries', 'products', name: 'product_countries_product_fk')
  end
end
