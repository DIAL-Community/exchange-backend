# frozen_string_literal: true

module Queries
  class CandidateDatasetQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CandidateDatasetType, null: true

    def resolve(slug:)
      candidate_dataset = CandidateDataset.find_by(slug:) if valid_slug?(slug)
      # Validate access to the current object or entity type.
      validate_access_to_instance(candidate_dataset || CandidateDataset.new)
      candidate_dataset
    end
  end

  class CandidateDatasetsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CandidateDatasetType], null: false

    def resolve(search:)
      validate_access_to_resource(CandidateDataset.new)
      candidate_datasets = CandidateDataset.order(:name)
      candidate_datasets = candidate_datasets.name_contains(search) unless search.blank?
      candidate_datasets
    end
  end
end
