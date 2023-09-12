# frozen_string_literal: true

class AddCreateStorefrontToCandidateOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column(:candidate_organizations, :create_storefront, :boolean, null: false, default: false)
  end
end
