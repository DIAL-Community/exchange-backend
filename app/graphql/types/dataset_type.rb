# frozen_string_literal: true

module Types
  class DatasetDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :dataset_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class DatasetType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :image_file, String, null: false
    field :website, String, null: true
    field :visualization_url, String, null: true
    field :geographic_coverage, String, null: true
    field :time_range, String, null: true
    field :license, String, null: true
    field :languages, String, null: true
    field :data_format, String, null: true
    field :aliases, GraphQL::Types::JSON, null: true
    field :tags, GraphQL::Types::JSON, null: true
    field :dataset_type, String, null: false

    field :dataset_descriptions, [Types::DatasetDescriptionType], null: true

    field :sectors, [Types::SectorType], null: true, method: :sectors_localized
    field :dataset_description,
      Types::DatasetDescriptionType,
      null: true,
      method: :dataset_description_localized

    field :parsed_description, String, null: true
    def parsed_description
      return if object.dataset_description_localized.nil?

      object_description = object.dataset_description_localized.description
      first_paragraph = Nokogiri::HTML.fragment(object_description).at('p')
      first_paragraph.nil? ? object_description : first_paragraph.inner_html
    end

    field :origins, [Types::OriginType], null: true
    field :organizations, [Types::OrganizationType], null: true
    field :countries, [Types::CountryType], null: true

    field :sustainable_development_goals, [Types::SustainableDevelopmentGoalType], null: true
    field :sustainable_development_goal_mapping, String,
      method: :current_sustainable_development_goal_mapping

    field :sdgs, [Types::SustainableDevelopmentGoalType], null: true
    field :sdgs_mapping, String, null: true, method: :current_sustainable_development_goal_mapping
    def sdgs
      object.sustainable_development_goals&.order(:number)
    end

    field :manual_update, Boolean, null: false
  end
end
