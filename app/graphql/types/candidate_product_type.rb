# frozen_string_literal: true

module Types
  class CandidateProductType < Types::BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :website, String, null: false
    field :repository, String, null: false
    field :submitter_email, String, null: false
    field :description, String, null: true

    field :commercial_product, Boolean, null: false

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
