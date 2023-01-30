# frozen_string_literal: true

class AddCommercialProductFlagToCandidateProducts < ActiveRecord::Migration[6.1]
  def change
    add_column(:candidate_products, :commercial_product, :boolean, null: false, default: false)
  end
end
