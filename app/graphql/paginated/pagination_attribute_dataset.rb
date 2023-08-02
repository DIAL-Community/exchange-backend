# frozen_string_literal: true

module Paginated
  class PaginationAttributeDataset < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :sectors, [String], required: false, default_value: []

    type Attributes::PaginationAttributes, null: false

    def resolve(search:, sectors:)
      datasets = Dataset.order(:name)
      unless search.blank?
        name_filter = datasets.name_contains(search)
        desc_filter = datasets.left_joins(:dataset_descriptions)
                              .where('LOWER(dataset_descriptions.description) like LOWER(?)', "%#{search}%")
        datasets = datasets.where(id: (name_filter + desc_filter).uniq)
      end

      filtered_sectors = sectors.reject { |x| x.nil? || x.empty? }
      unless filtered_sectors.empty?
        datasets = datasets.joins(:sectors)
                           .where(sectors: { id: filtered_sectors })
      end

      { total_count: datasets.count }
    end
  end
end
