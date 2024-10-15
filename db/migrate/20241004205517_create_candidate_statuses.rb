# frozen_string_literal: true

class CreateCandidateStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table(:candidate_statuses) do |t|
      t.string(:slug, null: false)
      t.string(:name, null: false)
      t.string(:description, null: false)

      t.boolean(:initial_status, null: false, default: false)
      t.boolean(:terminal_status, null: false, default: false)

      t.timestamps
    end

    create_table(:candidate_status_relationships) do |t|
      t.references(:current_candidate_status,
        null: false,
        index: false,
        foreign_key: {
          to_table: :candidate_statuses,
          name: 'candidate_status_relationships_current_candidate_status_fk'
        })
      t.references(:next_candidate_status,
        null: false,
        index: false,
        foreign_key: {
          to_table: :candidate_statuses,
          name: 'candidate_status_relationships_next_candidate_status_fk'
        })
      t.index([:current_candidate_status_id, :next_candidate_status_id],
        unique: true,
        name: 'candidate_status_relationships_main_index')
      t.index([:next_candidate_status_id, :current_candidate_status_id],
        unique: true,
        name: 'candidate_status_relationships_reverse_index')
      t.timestamps
    end
  end
end
