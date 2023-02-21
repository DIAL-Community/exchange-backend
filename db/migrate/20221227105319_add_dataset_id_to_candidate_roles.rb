# frozen_string_literal: true

class AddDatasetIdToCandidateRoles < ActiveRecord::Migration[6.1]
  def change
    add_reference(:candidate_roles, :dataset, foreign_key: { to_table: :datasets })
  end
end
