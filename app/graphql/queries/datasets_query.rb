# frozen_string_literal: true

module Queries
  class DatasetsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::DatasetType], null: false

    def resolve(search:)
      datasets = Dataset.order(:name)
      datasets = datasets.name_contains(search) unless search.blank?
      datasets
    end
  end

  class DatasetQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::DatasetType, null: true

    def resolve(slug:)
      Dataset.find_by(slug:)
    end
  end

  class OwnedDatasetsQuery < Queries::BaseQuery
    type [Types::DatasetType], null: false

    def resolve
      dataset_ids = context[:current_user].user_datasets.map(&:to_s) unless context[:current_user].nil?
      owned_datasets = Dataset.where('id in (?)', dataset_ids)
      owned_datasets
    end
  end
end
