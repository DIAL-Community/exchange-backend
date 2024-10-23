# frozen_string_literal: true

module Queries
  class CandidateRolesQuery < Queries::BaseQuery
    argument :product_id, String, required: false, default_value: nil
    argument :organization_id, String, required: false, default_value: nil
    argument :dataset_id, String, required: false, default_value: nil
    type [Types::CandidateRoleType], null: false

    def resolve(product_id:, organization_id:)
      validate_access_to_resource(CandidateRole.new)
      candidate_roles = CandidateRole.order(:created_at)
      candidate_roles = candidate_roles.where(product_id:) unless product_id.nil?
      candidate_roles = candidate_roles.where(organization_id:) unless organization_id.nil?
      candidate_roles
    end
  end

  class CandidateRoleQuery < Queries::BaseQuery
    argument :id, ID, required: false, default_value: nil
    argument :email, String, required: false, default_value: nil
    argument :product_id, String, required: false, default_value: nil
    argument :organization_id, String, required: false, default_value: nil
    argument :dataset_id, String, required: false, default_value: nil

    type Types::CandidateRoleType, null: true

    def resolve(id:, email:, product_id:, organization_id:, dataset_id:)
      validate_access_to_resource(CandidateRole.new)

      unless id.nil?
        candidate_role = CandidateRole.find(id)
        return candidate_role unless candidate_role.nil?
      end

      candidate_roles = CandidateRole
      candidate_roles = candidate_roles.where(product_id: product_id.to_i) if !product_id.nil? && !product_id.blank?
      candidate_roles = candidate_roles.where(dataset_id: dataset_id.to_i) if !dataset_id.nil? && !dataset_id.blank?

      if !organization_id.nil? && !organization_id.blank?
        candidate_roles = candidate_roles.where(organization_id: organization_id.to_i)
      end

      candidate_roles = candidate_roles.where(email:).order(updated_at: :desc) unless email.nil?
      candidate_roles.first
    end
  end
end
