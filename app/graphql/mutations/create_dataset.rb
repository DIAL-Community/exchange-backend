# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateDataset < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :aliases, GraphQL::Types::JSON, required: false
    argument :website, String, required: false
    argument :visualization_url, String, required: false
    argument :geographic_coverage, String, required: false
    argument :time_range, String, required: false
    argument :license, String, required: false
    argument :languages, String, required: false
    argument :data_format, String, required: false
    argument :dataset_type, String, required: true
    argument :description, String, required: true
    argument :image_file, ApolloUploadServer::Upload, required: false

    field :dataset, Types::DatasetType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, aliases:, website:, visualization_url: nil, geographic_coverage:,
      time_range:, dataset_type:, license:, languages:, data_format:, description:, image_file: nil)
      # Find the correct policy
      dataset = Dataset.find_by(slug:)
      dataset_policy = Pundit.policy(context[:current_user], dataset || Dataset.new)

      if dataset.nil? && !dataset_policy.create_allowed?
        return {
          dataset: nil,
          errors: ['Creating / editing dataset is not allowed.']
        }
      end

      if !dataset.nil? && !dataset_policy.edit_allowed?
        return {
          dataset: nil,
          errors: ['Creating / editing dataset is not allowed.']
        }
      end

      if dataset.nil?
        dataset = Dataset.new(name:)
        dataset.slug = reslug_em(name)

        if Dataset.where(slug: reslug_em(name)).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Dataset.slug_simple_starts_with(dataset.slug)
                                   .order(slug: :desc)
                                   .first
          dataset.slug += generate_offset(first_duplicate)
        end
      end

      dataset.name = name
      dataset.aliases = aliases
      dataset.website = website
      dataset.dataset_type = dataset_type
      dataset.visualization_url = visualization_url
      dataset.geographic_coverage = geographic_coverage
      dataset.time_range = time_range
      dataset.license = license
      dataset.languages = languages
      dataset.data_format = data_format

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(dataset)
        dataset.save!

        unless image_file.nil?
          uploader = LogoUploader.new(dataset, image_file.original_filename, context[:current_user])
          begin
            uploader.store!(image_file)
          rescue StandardError => e
            puts "Unable to save image for: #{dataset.name}. Standard error: #{e}."
          end
          dataset.auditable_image_changed(image_file.original_filename)
        end

        dataset_desc = DatasetDescription.find_by(dataset_id: dataset.id, locale: I18n.locale)
        dataset_desc = DatasetDescription.new if dataset_desc.nil?
        dataset_desc.description = description
        dataset_desc.dataset_id = dataset.id
        dataset_desc.locale = I18n.locale

        assign_auditable_user(dataset_desc)
        dataset_desc.save!

        successful_operation = true
      end

      if successful_operation
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
