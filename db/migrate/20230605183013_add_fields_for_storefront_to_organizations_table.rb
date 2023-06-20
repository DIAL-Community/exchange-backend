# frozen_string_literal: true

class AddFieldsForStorefrontToOrganizationsTable < ActiveRecord::Migration[7.0]
  def change
    add_column(:organizations, :has_storefront, :boolean, null: false, default: false)
    add_column(:organizations, :hero_url, :string, null: true)
    add_column(:organizations, :specialties, :jsonb, null: false, default: [])
    add_column(:organizations, :certifications, :jsonb, null: false, default: [])
  end
end
