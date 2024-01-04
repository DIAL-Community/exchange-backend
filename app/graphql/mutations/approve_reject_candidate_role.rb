# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class ApproveRejectCandidateRole < Mutations::BaseMutation
    include Modules::Slugger

    argument :candidate_role_id, ID, required: true
    argument :action, String, required: true

    field :candidate_role, Types::CandidateRoleType, null: true
    field :errors, [String], null: true

    def resolve(candidate_role_id:, action:)
      unless an_admin
        return {
          candidate_role: nil,
          errors: ['Must be admin to approve or reject candidate role']
        }
      end

      candidate_role = CandidateRole.find_by(id: candidate_role_id)

      if action == 'APPROVE'
        successful_operation = approve_candidate(candidate_role)
      elsif action == 'REJECT'
        successful_operation = reject_candidate(candidate_role)
      else
        return {
          candidate_role: nil,
          errors: ['Wrong action provided']
        }
      end

      if successful_operation
        AdminMailer
          .with(
            email: candidate_role.email,
            rejected: candidate_role.rejected,
            dataset_id: candidate_role.dataset_id,
            organization_id: candidate_role.organization_id,
            product_id: candidate_role.product_id
          )
          .notify_owner_approval
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

    def approve_candidate(candidate_role)
      user = User.find_by(email: candidate_role.email)

      return false if user.nil?

      successful_operation = false
      ActiveRecord::Base.transaction do
        user.roles |= candidate_role.roles

        user.organization_id = candidate_role.organization_id unless candidate_role.organization_id.nil?

        unless candidate_role.product_id.nil?
          product = Product.find_by(id: candidate_role.product_id)
          user.user_products << product.id unless product.nil? || user.user_products.include?(product.id)
        end

        unless candidate_role.dataset_id.nil?
          dataset = Dataset.find_by(id: candidate_role.dataset_id)
          user.user_datasets << dataset.id unless dataset.nil? || user.user_datasets.include?(dataset.id)
        end

        if candidate_role.rejected.nil?
          candidate_role.rejected = false
          candidate_role.approved_date = Time.now
          candidate_role.approved_by_id = context[:current_user].id
        end

        candidate_role.save!
        user.save!

        successful_operation = true
      end

      successful_operation
    end

    def reject_candidate(candidate_role)
      if candidate_role.rejected.nil?
        candidate_role.rejected = true
        candidate_role.rejected_date = Time.now
        candidate_role.rejected_by_id = context[:current_user].id
      end

      true if candidate_role.save!
    end
  end
end
