# frozen_string_literal: true

module Paginated
  class PaginationAttributeCandidateDataset < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      # Validate access to the current entity type.
      validate_access_to_resource(CandidateDataset.new)

      candidate_datasets = CandidateDataset.order(:name)
      unless search.blank?
        name_filter = candidate_datasets.name_contains(search)
        description_filter = candidate_datasets.where('LOWER(description) like LOWER(?)', "%#{search}%")
        candidate_datasets = candidate_datasets.where(id: (name_filter + description_filter).uniq)
      end

      { total_count: candidate_datasets.count }
    end
  end
end
