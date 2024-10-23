# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class ApplyAsContentEditor < Mutations::BaseMutation
    include Modules::Slugger

    field :candidate_role, Types::CandidateRoleType, null: true
    field :errors, [String], null: true

    def resolve
      candidate_role_policy = Pundit.policy(context[:current_user], CandidateRole.new)
      unless candidate_role_policy.create_allowed?
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
        AdminMailer
          .with(email: candidate_role.email)
          .notify_new_content_editor
          .deliver_now
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
