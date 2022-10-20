# frozen_string_literal: true

class CreateUseCaseStepsDatasets < ActiveRecord::Migration[6.1]
  def change
    create_table(:use_case_steps_datasets) do |t|
      t.bigint('use_case_step_id', null: false)
      t.bigint('dataset_id', null: false)
      t.index(%w[use_case_step_id dataset_id], name: 'use_case_steps_datasets_idx', unique: true)
      t.index(%w[dataset_id use_case_step_id], name: 'datasets_use_case_steps_idx', unique: true)
    end

    add_foreign_key('use_case_steps_datasets', 'use_case_steps', name: 'use_case_steps_datasets_step_fk')
    add_foreign_key('use_case_steps_datasets', 'datasets', name: 'use_case_steps_datasets_dataset_fk')
  end
end
