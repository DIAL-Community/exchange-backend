# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class ApproveRejectCandidateDataset < Mutations::BaseMutation
    include Modules::Slugger

    argument :slug, String, required: true
    argument :action, String, required: true

    field :candidate_dataset, Types::CandidateDatasetType, null: true
    field :errors, [String], null: true

    def resolve(slug:, action:)
      unless an_admin
        return {
          candidate_dataset: nil,
          errors: ['Must be admin to approve or reject candidate dataset']
        }
      end

      candidate_dataset = CandidateDataset.find_by(slug:)

      if action == 'APPROVE'
        successful_operation = approve_candidate(candidate_dataset)
      elsif action == 'REJECT'
        successful_operation = reject_candidate(candidate_dataset)
      else
        return {
          candidate_dataset: nil,
          errors: ['Wrong action provided']
        }
      end

      if successful_operation
        AdminMailer
          .with(rejected: action == 'REJECT', user_email: candidate_dataset.submitter_email)
          .notify_candidate_dataset_approval
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

    def reject_candidate(candidate_dataset)
      candidate_dataset.rejected = true
      candidate_dataset.rejected_date = Time.now
      candidate_dataset.rejected_by_id = context[:current_user].id

      return true if candidate_dataset.save!
    end

    def approve_candidate(candidate_dataset)
      candidate_dataset.rejected = false
      candidate_dataset.approved_date = Time.now
      candidate_dataset.approved_by_id = context[:current_user].id

      dataset = Dataset.new(name: candidate_dataset.name,
                            website: candidate_dataset.website,
                            visualization_url: candidate_dataset.visualization_url,
                            dataset_type: candidate_dataset.dataset_type)

      slug = reslug_em(candidate_dataset.name)
      # Check if we need to add _dup to the slug.
      first_duplicate = Dataset.slug_simple_starts_with(slug)
                               .order(slug: :desc)
                               .first
      if !first_duplicate.nil?
        dataset.slug = slug + generate_offset(first_duplicate)
      else
        dataset.slug = slug
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(dataset)
        dataset.save!

        dataset_desc = DatasetDescription.find_by(dataset_id: dataset.id, locale: I18n.locale)
        dataset_desc = DatasetDescription.new if dataset_desc.nil?
        dataset_desc.description = candidate_dataset.description
        dataset_desc.dataset_id = dataset.id
        dataset_desc.locale = I18n.locale

        assign_auditable_user(dataset_desc)
        dataset_desc.save!
        candidate_dataset.save!

        successful_operation = true
      end

      successful_operation
    end
  end
end
