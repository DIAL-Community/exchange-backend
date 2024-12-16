# frozen_string_literal: true

class AddExtraAttributesToCandidateProducts < ActiveRecord::Migration[7.0]
  def change
    add_column(:candidate_products, :extra_attributes, :jsonb, default: [])
  end
end
