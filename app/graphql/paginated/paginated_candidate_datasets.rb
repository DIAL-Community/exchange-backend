# frozen_string_literal: true

module Paginated
  class PaginatedCandidateDatasets < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::CandidateDatasetType], null: false

    def resolve(search:, offset_attributes:)
      if !unsecure_read_allowed && context[:current_user].nil?
        return []
      end

      return [] unless an_admin

      candidate_products = CandidateDataset.order(rejected: :desc)
                                           .order(created_at: :desc)
                                           .order(:name)
      unless search.blank?
        name_filter = candidate_products.name_contains(search)
        description_filter = candidate_products.where('LOWER(description) like LOWER(?)', "%#{search}%")
        candidate_products = candidate_products.where(id: (name_filter + description_filter).uniq)
      end

      offset_params = offset_attributes.to_h
      candidate_products.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
