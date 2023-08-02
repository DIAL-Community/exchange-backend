# frozen_string_literal: true

module Paginated
  class PaginatedDatasets < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :sectors, [String], required: false, default_value: []
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::DatasetType], null: false

    def resolve(search:, sectors:, offset_attributes:)
      datasets = Dataset.order(:name)
      unless search.blank?
        name_filter = datasets.name_contains(search)
        desc_filter = datasets.left_joins(:dataset_descriptions)
                              .where('LOWER(dataset_descriptions.description) like LOWER(?)', "%#{search}%")
        datasets = datasets.where(id: (name_filter + desc_filter).uniq)
      end

      filtered_sectors = sectors.reject { |x| x.nil? || x.empty? }
      unless filtered_sectors.empty?
        datasets = datasets.joins(:sectors).where(sectors: { id: filtered_sectors })
      end

      offset_params = offset_attributes.to_h
      datasets.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
