# frozen_string_literal: true

module Queries
  class CandidateRolesQuery < Queries::BaseQuery
    argument :product_id, String, required: true
    argument :organization_id, String, required: true
    type [Types::CandidateRoleType], null: false

    def resolve(product_id:, organization_id:)
      return [] unless an_admin

      candidate_roles = CandidateRole
      candidate_roles = candidate_roles.where(product_id: product_id) unless product_id.nil?

      candidate_roles = candidate_roles.where(organization_id: organization_id) unless organization_id.nil?
      candidate_roles
    end
  end

  class CandidateRoleQuery < Queries::BaseQuery
    argument :product_id, String, required: true
    argument :organization_id, String, required: true
    argument :dataset_id, String, required: true
    argument :email, String, required: true

    type Types::CandidateRoleType, null: true

    def resolve(product_id:, organization_id:, dataset_id:, email:)
      return nil if context[:current_user].nil?

      candidate_roles = CandidateRole
      candidate_roles = candidate_roles.where(product_id: product_id.to_i) if !product_id.nil? && !product_id.blank?
      candidate_roles = candidate_roles.where(dataset_id: dataset_id.to_i) if !dataset_id.nil? && !dataset_id.blank?

      if !organization_id.nil? && !organization_id.blank?
        candidate_roles = candidate_roles.where(organization_id: organization_id.to_i)
      end

      candidate_roles = candidate_roles.where(email: email).order(updated_at: :desc) unless email.nil?
      candidate_roles.first
    end
  end

  class SearchCandidateRolesQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: true
    type Types::CandidateRoleType.connection_type, null: false

    def resolve(search:)
      return unless an_admin

      candidate_roles = CandidateRole.order(rejected: :desc).order(:email)
      candidate_roles = candidate_roles.email_contains(search) unless search.blank?
      candidate_roles
    end
  end
end
