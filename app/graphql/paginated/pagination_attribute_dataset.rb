# frozen_string_literal: true

module Paginated
  class PaginationAttributeDataset < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :sectors, [String], required: false, default_value: []
    argument :sdgs, [String], required: false, default_value: []
    argument :tags, [String], required: false, default_value: []
    argument :origins, [String], required: false, default_value: []
    argument :dataset_types, [String], required: false, default_value: []

    type Attributes::PaginationAttributes, null: false

    def resolve(search:, sectors:, sdgs:, tags:, origins:, dataset_types:)
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

      filtered_sdgs = sdgs.reject { |x| x.nil? || x.empty? }
      unless filtered_sdgs.empty?
        datasets = datasets.joins(:sustainable_development_goals)
                           .where(sustainable_development_goals: { id: filtered_sdgs })
      end

      filtered_origins = origins.reject { |x| x.nil? || x.empty? }
      unless filtered_origins.empty?
        datasets = datasets.joins(:origins)
                           .where(origins: { id: filtered_origins })
      end

      filtered_tags = tags.reject { |x| x.nil? || x.blank? }
      unless filtered_tags.empty?
        datasets = datasets.where(
          "tags @> '{#{filtered_tags.join(',').downcase}}'::varchar[] or " \
          "tags @> '{#{filtered_tags.join(',')}}'::varchar[]"
        )
      end

      unless dataset_types.empty?
        datasets = datasets.where(dataset_type: dataset_types)
      end

      { total_count: datasets.count }
    end
  end
end