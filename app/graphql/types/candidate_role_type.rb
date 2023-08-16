# frozen_string_literal: true

module Types
  class CandidateRoleType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :roles, [String], null: true
    field :description, String, null: true
    field :product_id, String, null: true
    field :organization_id, String, null: true
    field :dataset_id, String, null: true

    field :created_at, GraphQL::Types::ISO8601Date, null: true

    field :product, Types::ProductType, null: true, method: :candidate_role_product
    field :organization, Types::OrganizationType, null: true, method: :candidate_role_organization
    field :dataset, Types::DatasetType, null: true, method: :candidate_role_dataset

    field :rejected, Boolean, null: true
    field :rejected_date, GraphQL::Types::ISO8601Date, null: true
    field :rejected_by, String, null: true

    field :approved_date, GraphQL::Types::ISO8601Date, null: true
    field :approved_by, String, null: true

    def rejected_by
      an_admin = context[:current_user]&.roles&.include?('admin')
      if an_admin
        approver = User.find(object.approved_by_id)
        approved_by = approver&.email
      end
      approved_by
    end

    def approved_by
      an_admin = context[:current_user]&.roles&.include?('admin')
      if an_admin
        approver = User.find(object.approved_by_id)
        rejected_by = approver&.email
      end
      rejected_by
    end
  end
end
