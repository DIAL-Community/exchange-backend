# frozen_string_literal: true

module Types
  class CandidateDatasetType < Types::BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :website, String, null: false
    field :dataset_type, String, null: false
    field :visualization_url, String, null: true
    field :description, String, null: false

    field :created_at, GraphQL::Types::ISO8601Date, null: true

    field :rejected, Boolean, null: true
    field :rejected_date, GraphQL::Types::ISO8601Date, null: true
    field :rejected_by, String, null: true

    field :approved_date, GraphQL::Types::ISO8601Date, null: true
    field :approved_by, String, null: true

    def rejected_by
      an_admin = context[:current_user]&.roles&.include?('admin')
      if an_admin && !object.rejected_by_id.nil?
        rejecting_user = User.find_by(id: object.rejected_by_id)
        rejected_by = rejecting_user&.email
      end
      rejected_by
    end

    def approved_by
      an_admin = context[:current_user]&.roles&.include?('admin')
      if an_admin && !object.approved_by_id.nil?
        approving_user = User.find_by(id: object.approved_by_id)
        approved_by = approving_user&.email
      end
      approved_by
    end

    field :data_type, String, null: false
    field :submitter_email, String, null: false
  end
end
