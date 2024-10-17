# frozen_string_literal: true

class RenameColumnOrgTypeOnProductsAndProjects < ActiveRecord::Migration[7.0]
  def change
    rename_column(:organization_products, :org_type, :organization_type)
    rename_column(:projects_organizations, :org_type, :organization_type)
  end
end
