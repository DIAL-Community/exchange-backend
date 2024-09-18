# frozen_string_literal: true

class CreateCandidateResources < ActiveRecord::Migration[7.0]
  def change
    create_table(:candidate_resources) do |t|
      t.string(:name, null: false)
      t.string(:slug, null: false)
      t.string(:description, null: false)
      t.datetime(:published_date, null: false, default: '2024-08-27 00:00:00 +0000')

      t.string(:resource_type, null: false)
      t.string(:resource_link, null: false)
      t.string(:link_description, null: false)

      t.string(:submitter_email, null: false)

      t.boolean(:rejected, null: true)

      t.datetime(:rejected_date, null: true)
      t.references(
        :rejected_by,
        index: true,
        foreign_key: {
          to_table: :users,
          name: 'candidate_resources_rejected_by_fk'
        }
      )

      t.datetime(:approved_date, null: true)
      t.references(
        :approved_by,
        index: true,
        foreign_key: {
          to_table: :users,
          name: 'candidate_resources_approved_by_fk'
        }
      )
      t.timestamps
    end
  end
end
