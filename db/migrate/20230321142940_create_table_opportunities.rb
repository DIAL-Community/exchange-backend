# frozen_string_literal: true

class CreateTableOpportunities < ActiveRecord::Migration[6.1]
  def change
    create_table(:opportunities, force: :cascade) do |t|
      t.string(:name, null: false)
      t.string(:slug, null: false, index: { unique: true, name: 'opportunities_unique_slug' })
      t.string(:description, null: false)

      t.string(:contact_name, null: false)
      t.string(:contact_email, null: false)

      t.datetime(:opening_date, null: false, default: -> { 'CURRENT_TIMESTAMP' })
      t.datetime(:closing_date, null: false, default: -> { 'CURRENT_TIMESTAMP' })

      t.column(:opportunity_type, 'opportunity_type_type', null: false, default: 'OTHER')
      t.column(:opportunity_status, 'opportunity_status_type', null: false, default: 'UPCOMING')

      t.string(:web_address)
      t.string(:requirements)
      t.decimal(:budget, precision: 12, scale: 2)

      t.string(:tags, default: [], array: true)
      t.references(:origin, index: true, foreign_key: true)

      t.timestamps
    end
  end
end
