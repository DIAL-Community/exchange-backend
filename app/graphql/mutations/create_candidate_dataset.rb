# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateCandidateDataset < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :website, String, required: true
    argument :visualization_url, String, required: false
    argument :dataset_type, String, required: true
    argument :submitter_email, String, required: true
    argument :description, String, required: true
    argument :captcha, String, required: true

    field :candidate_dataset, Types::CandidateDatasetType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, website:, visualization_url:, dataset_type:, submitter_email:, description:, captcha:)
      unless !context[:current_user].nil?
        return {
          candidate_dataset: nil,
          errors: ['Must be logged in to create a candidate dataset']
        }
      end

      candidate_dataset = CandidateDataset.find_by(slug:)
      if candidate_dataset.nil?
        slug = slug_em(name)
        candidate_dataset = CandidateDataset.new(name:, slug:)

        # Check if we need to add _dup to the slug.
        first_duplicate = CandidateDataset.slug_simple_starts_with(slug)
                                          .order(slug: :desc).first
        unless first_duplicate.nil?
          candidate_dataset.slug = slug + generate_offset(first_duplicate)
        end
      end

      candidate_dataset.name = name
      candidate_dataset.website = website
      candidate_dataset.visualization_url = visualization_url
      candidate_dataset.dataset_type = dataset_type.upcase
      candidate_dataset.submitter_email = submitter_email
      candidate_dataset.description = description

      if candidate_dataset.save! && captcha_verification(captcha)
        AdminMailer
          .with(candidate_name: candidate_dataset.name)
          .notify_new_candidate_dataset
          .deliver_now
        # Successful creation, return the created object with no errors
        {
          candidate_dataset:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          candidate_dataset: nil,
          errors: candidate_dataset.errors.full_messages
        }
      end
    end
  end
end
