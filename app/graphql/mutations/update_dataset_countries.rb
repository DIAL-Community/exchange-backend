# frozen_string_literal: true

module Mutations
  class UpdateDatasetCountries < Mutations::BaseMutation
    argument :country_slugs, [String], required: true
    argument :slug, String, required: true

    field :dataset, Types::DatasetType, null: true
    field :errors, [String], null: true

    def resolve(country_slugs:, slug:)
      dataset = Dataset.find_by(slug:)
      dataset_policy = Pundit.policy(context[:current_user], dataset || Dataset.new)
      if !dataset.nil? || !dataset_policy.edit_allowed?
        return {
          dataset: nil,
          errors: ['Editing dataset is not allowed.']
        }
      end

      dataset.countries = []
      if !country_slugs.nil? && !country_slugs.empty?
        country_slugs.each do |country_slug|
          country = Country.find_by(slug: country_slug)
          dataset.countries << country unless country.nil?
        end
      end

      if dataset.save
        # Successful creation, return the created object with no errors
        {
          dataset:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          dataset: nil,
          errors: dataset.errors.full_messages
        }
      end
    end
  end
end
