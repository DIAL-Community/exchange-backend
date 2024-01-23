# frozen_string_literal: true

module Paginated
  class PaginatedDatasets < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :sectors, [String], required: false, default_value: []
    argument :sdgs, [String], required: false, default_value: []
    argument :tags, [String], required: false, default_value: []
    argument :origins, [String], required: false, default_value: []
    argument :dataset_types, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::DatasetType], null: false

    def resolve(search:, sectors:, sdgs:, tags:, origins:, dataset_types:, countries:, offset_attributes:)
      if !unsecure_read_allowed && context[:current_user].nil?
        return []
      end

      datasets = Dataset.order(:name)
      unless search.blank?
        name_filter = datasets.name_contains(search)
        desc_filter = datasets.left_joins(:dataset_descriptions)
                              .where('LOWER(dataset_descriptions.description) like LOWER(?)', "%#{search}%")
        datasets = datasets.where(id: (name_filter + desc_filter).uniq)
      end

      filtered_countries = countries.reject { |x| x.nil? || x.empty? }
      unless filtered_countries.empty?
        datasets = datasets.joins(:countries)
                           .where(countries: { id: filtered_countries })
      end

      filtered_sectors = sectors.reject { |x| x.nil? || x.empty? }
      unless filtered_sectors.empty?
        datasets = datasets.joins(:sectors).where(sectors: { id: filtered_sectors })
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
          "datasets.tags @> '{#{filtered_tags.join(',').downcase}}'::varchar[] or " \
          "datasets.tags @> '{#{filtered_tags.join(',')}}'::varchar[]"
        )
      end

      unless dataset_types.empty?
        datasets = datasets.where(dataset_type: dataset_types)
      end

      offset_params = offset_attributes.to_h
      datasets.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
