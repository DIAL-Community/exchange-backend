# frozen_string_literal: true

module Queries
  class CandidateDatasetsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CandidateDatasetType], null: false

    def resolve(search:)
      return [] unless an_admin

      candidate_datasets = CandidateDataset.order(:name)
      candidate_datasets = candidate_datasets.name_contains(search) unless search.blank?
      candidate_datasets
    end
  end

  class CandidateDatasetQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CandidateDatasetType, null: true

    def resolve(slug:)
      return nil unless an_admin

      CandidateDataset.find_by(slug:)
    end
  end
end
