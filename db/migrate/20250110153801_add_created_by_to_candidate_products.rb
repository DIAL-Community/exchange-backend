# frozen_string_literal: true

class AddCreatedByToCandidateProducts < ActiveRecord::Migration[7.0]
  def change
    add_reference(:candidate_products, :created_by, foreign_key: { to_table: :users })
  end
end
