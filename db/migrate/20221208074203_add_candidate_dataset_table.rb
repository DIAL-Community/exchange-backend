# frozen_string_literal: true

class AddCandidateDatasetTable < ActiveRecord::Migration[6.1]
  def change
    create_table(:candidate_datasets) do |t|
      t.string(:name, null: false)
      t.string(:slug, unique: true, null: false)
      t.string(:data_url, null: false)
      t.string(:data_visualization_url, null: true)
      t.string(:data_type, null: false)
      t.string(:submitter_email, null: false)
      t.string(:description, null: false)
      t.boolean(:rejected, null: true)
      t.datetime(:rejected_date, null: true)
      t.references(:rejected_by, index: true, foreign_key: { to_table: :users })
      t.datetime(:approved_date, null: true)
      t.references(:approved_by, index: true, foreign_key: { to_table: :users })
      t.timestamps
    end
  end
end
