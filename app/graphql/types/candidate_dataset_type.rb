# frozen_string_literal: true

module Types
  class CandidateDatasetType < Types::BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :data_url, String, null: false
    field :data_visualization_url, String, null: true
    field :description, String, null: false
    field :rejected, Boolean, null: true
  end
end
