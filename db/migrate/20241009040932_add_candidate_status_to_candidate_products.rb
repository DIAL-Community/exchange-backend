# frozen_string_literal: true

class AddCandidateStatusToCandidateProducts < ActiveRecord::Migration[7.0]
  def change
    add_reference(
      :candidate_products,
      :candidate_status,
      foreign_key: {
        to_table: :candidate_statuses,
        on_delete: :nullify
      }
    )
  end
end
