# frozen_string_literal: true

module Paginated
  class PaginatedCandidateDatasets < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::CandidateDatasetType], null: false

    def resolve(search:, offset_attributes:)
      # Validate access to the current entity type.
      validate_access_to_resource(CandidateDataset.new)

      candidate_datasets = CandidateDataset.order(rejected: :desc)
                                           .order(created_at: :desc)
                                           .order(:name)
      unless search.blank?
        name_filter = candidate_datasets.name_contains(search)
        description_filter = candidate_datasets.where('LOWER(description) like LOWER(?)', "%#{search}%")
        candidate_datasets = candidate_datasets.where(id: (name_filter + description_filter).uniq)
      end

      offset_params = offset_attributes.to_h
      candidate_datasets.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
