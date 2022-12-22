# frozen_string_literal: true

module Queries
  class CandidateDatasetsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CandidateDatasetType], null: true

    def resolve(search:)
      return nil if context[:current_user].nil? || !context[:current_user].roles.include?('admin')

      candidate_datasets = CandidateDataset.order(:name)
      candidate_datasets = candidate_datasets.name_contains(search) unless search.blank?
      candidate_datasets
    end
  end

  class SearchCandidateDatasetsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: true
    type Types::CandidateDatasetType.connection_type, null: true

    def resolve(search:)
      return nil if context[:current_user].nil? || !context[:current_user].roles.include?('admin')

      candidate_datasets = CandidateDataset.order(rejected: :desc).order(:slug)
      candidate_datasets = candidate_datasets.name_contains(search) unless search.blank?
      candidate_datasets
    end
  end
end
