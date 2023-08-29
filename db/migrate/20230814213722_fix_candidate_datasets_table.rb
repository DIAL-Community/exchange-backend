# frozen_string_literal: true

class FixCandidateDatasetsTable < ActiveRecord::Migration[7.0]
  def change
    rename_column(:candidate_datasets, :data_url, :website)
    rename_column(:candidate_datasets, :data_visualization_url, :visualization_url)
    rename_column(:candidate_datasets, :data_type, :dataset_type)
  end
end
