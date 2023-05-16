# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class ApplyAsContentEditor < Mutations::BaseMutation
    include Modules::Slugger

    field :candidate_role, Types::CandidateRoleType, null: true
    field :errors, [String], null: true

    def resolve
      if context[:current_user].nil?
        return {
          candidate_role: nil,
          errors: ['Must be logged in to apply as content editor.']
        }
      end

      role = 'content_editor'
      candidate_role = CandidateRole.find_by(
        email: context[:current_user].email,
        roles: [role],
        rejected: nil
      )

      if candidate_role.nil?
        candidate_role = CandidateRole.new(
          roles: [role],
          email: context[:current_user].email,
          description: 'Content editor role requested from the new UX.'
        )
      else
        return {
          candidate_role: nil,
          errors: ['Pending content editor request already exists.']
        }
      end

      if candidate_role.save!
        # Successful creation, return the created object with no errors
        {
          candidate_role:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          candidate_role: nil,
          errors: candidate_role.errors.full_messages
        }
      end
    end
  end
end
