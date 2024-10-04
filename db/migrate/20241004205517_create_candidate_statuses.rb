# frozen_string_literal: true

class CreateCandidateStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table(:candidate_statuses) do |t|
      t.string(:name, null: false)
      t.string(:description, null: false)

      t.references(:current_candidate_status, foreign_key: { to_table: :candidate_statuses })

      t.timestamps
    end
  end
end
