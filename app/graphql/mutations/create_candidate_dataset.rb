# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateCandidateDataset < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :data_url, String, required: true
    argument :data_visualization_url, String, required: false
    argument :data_type, String, required: true
    argument :submitter_email, String, required: true
    argument :description, String, required: true
    argument :captcha, String, required: true

    field :candidate_dataset, Types::CandidateDatasetType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, data_url:, data_visualization_url:, data_type:, submitter_email:, description:, captcha:)
      unless !context[:current_user].nil?
        return {
          candidate_dataset: nil,
          errors: ['Must be logged in to create an candidate dataset']
        }
      end

      candidate_dataset = CandidateDataset.find_by(slug: slug)
      if candidate_dataset.nil?
        candidate_dataset = CandidateDataset.new(name: name,
                                                 data_url: data_url,
                                                 data_visualization_url: data_visualization_url,
                                                 data_type: data_type,
                                                 submitter_email: submitter_email,
                                                 description: description)
        slug = slug_em(name)

        # Check if we need to add _dup to the slug.
        first_duplicate = CandidateDataset.slug_simple_starts_with(slug_em(name))
                                          .order(slug: :desc).first
        if !first_duplicate.nil?
          candidate_dataset.slug = slug + generate_offset(first_duplicate)
        else
          candidate_dataset.slug = slug
        end
      else
        return {
          candidate_dataset: nil,
          errors: ['Candidate dataset already created']
        }
      end

      if candidate_dataset.save! && captcha_verification(captcha)
        # Successful creation, return the created object with no errors
        {
          candidate_dataset: candidate_dataset,
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
