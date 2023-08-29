# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class ApplyAsOwner < Mutations::BaseMutation
    include Modules::Slugger

    argument :entity, String, required: true
    argument :entity_id, Integer, required: true

    field :candidate_role, Types::CandidateRoleType, null: true
    field :errors, [String], null: true

    def resolve(entity:, entity_id:)
      if context[:current_user].nil?
        return {
          candidate_role: nil,
          errors: ['Must be logged in to apply as owner']
        }
      elsif entity == 'PRODUCT' && a_product_owner(entity_id)
        return {
          candidate_role: nil,
          errors: ['You are owner of this product']
        }
      elsif entity == 'ORGANIZATION' && an_org_owner(entity_id)
        return {
          candidate_role: nil,
          errors: ['You are owner of this organization']
        }
      elsif entity == 'DATASET' && a_dataset_owner(entity_id)
        return {
          candidate_role: nil,
          errors: ['You are owner of this dataset']
        }
      end

      if entity == 'PRODUCT'
        role = 'product_user'
        candidate_role = CandidateRole.find_by(
          email: context[:current_user].email,
          roles: [role],
          product_id: entity_id,
          rejected: nil
        )
      elsif entity == 'ORGANIZATION'
        role = 'org_user'
        candidate_role = CandidateRole.find_by(
          email: context[:current_user].email,
          roles: [role],
          organization_id: entity_id,
          rejected: nil
        )
      elsif entity == 'DATASET'
        role = 'dataset_user'
        candidate_role = CandidateRole.find_by(
          email: context[:current_user].email,
          roles: [role],
          dataset_id: entity_id,
          rejected: nil
        )
      else
        return {
          candidate_role: nil,
          errors: ['Wrong entity provided']
        }
      end

      description = "#{entity.titlecase} ownership requested from the new UX."
      if candidate_role.nil?
        candidate_role = CandidateRole.new(
          email: context[:current_user].email,
          roles: [role]
        )
      else
        return {
          candidate_role: nil,
          errors: ['Already applied']
        }
      end

      if entity == 'PRODUCT'
        candidate_role.product_id = entity_id
        entity = Product.find(entity_id)
        description += " Product: '#{entity.name}'."
      elsif entity == 'ORGANIZATION'
        candidate_role.organization_id = entity_id
        entity = Organization.find(entity_id)
        description += " Organization: '#{entity.name}'."
      elsif entity == 'DATASET'
        candidate_role.dataset_id = entity_id
        entity = Dataset.find(entity_id)
        description += " Dataset: '#{entity.name}'."
      end
      candidate_role.description = description

      if candidate_role.save!
        AdminMailer
          .with(user: {
            email: candidate_role.email,
            dataset_id: candidate_role.dataset_id,
            organization_id: candidate_role.organization_id,
            product_id: candidate_role.product_id
          })
          .notify_user_request
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
