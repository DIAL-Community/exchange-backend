# frozen_string_literal: true

class CreateCandidateResourcesCountries < ActiveRecord::Migration[7.0]
  def change
    create_table(:candidate_resources_countries) do |t|
      t.bigint('candidate_resource_id', null: false)
      t.bigint('country_id', null: false)
      t.index(%w[candidate_resource_id country_id], name: 'candidate_resources_countries_idx', unique: true)
      t.index(%w[country_id candidate_resource_id], name: 'countries_candidate_resources_idx', unique: true)
      t.timestamps
    end

    add_foreign_key(
      'candidate_resources_countries',
      'candidate_resources',
      name: 'candidate_resources_countries_candidate_resources_fk'
    )
    add_foreign_key(
      'candidate_resources_countries',
      'countries',
      name: 'candidate_resources_countries_countries_fk'
    )
  end
end
