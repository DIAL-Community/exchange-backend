# frozen_string_literal: true

class RenameTablesToCorrectStructure < ActiveRecord::Migration[7.0]
  def change
    rename_table(:product_countries, :products_countries)
    rename_table(:organizations_contacts, :organization_contacts)
    rename_table(:organizations_datasets, :organization_datasets)
    rename_table(:organizations_products, :organization_products)
  end
end
