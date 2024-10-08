# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateCandidateStatus < Mutations::BaseMutation
    include Modules::Slugger

    argument :slug, String, required: true
    argument :name, String, required: true
    argument :description, String, required: false, default_value: nil
    argument :initial_status, Boolean, required: true, default_value: false
    argument :terminal_status, Boolean, required: true, default_value: false
    argument :next_candidate_status_slugs, [String], required: true, default_value: []

    field :candidate_status, Types::CandidateStatusType, null: true
    field :errors, [String], null: true

    def resolve(slug:, name:, description:, initial_status:, terminal_status:, next_candidate_status_slugs:)
      unless an_admin
        return {
          candidate_status: nil,
          errors: ['Must be admin or content editor to edit a candidate status.']
        }
      end

      candidate_status = CandidateStatus.find_by(slug:)
      if candidate_status.nil?
        candidate_status = CandidateStatus.new(name:, slug: reslug_em(name))

        # Check if we need to add _dup to the slug.
        first_duplicate = CandidateStatus.slug_simple_starts_with(candidate_status.slug)
                                         .order(slug: :desc)
                                         .first
        unless first_duplicate.nil?
          candidate_status.slug += generate_offset(first_duplicate)
        end
      end

      # Update field of the candidate_status object
      candidate_status.name = name
      candidate_status.description = description
      candidate_status.initial_status = initial_status
      candidate_status.terminal_status = terminal_status

      next_candidate_statuses = []
      next_candidate_status_slugs.each do |next_candidate_status_slug|
        next_candidate_status = CandidateStatus.find_by(slug: next_candidate_status_slug)
        next_candidate_statuses << next_candidate_status unless next_candidate_status.nil?
      end
      candidate_status.next_candidate_statuses = next_candidate_statuses

      if candidate_status.save
        # Successful creation, return the created object with no errors
        {
          candidate_status:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          candidate_status: nil,
          errors: candidate_status.errors.full_messages
        }
      end
    end
  end
end
