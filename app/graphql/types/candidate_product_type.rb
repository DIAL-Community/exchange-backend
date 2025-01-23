# frozen_string_literal: true

module Types
  class CandidateProductType < Types::BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :website, String, null: false
    field :repository, String, null: false

    field :submitter_email, String, null: true
    def submitter_email
      unless context[:current_user].nil?
        object.submitter_email
      end
    end

    field :extra_attributes, [GraphQL::Types::JSON], null: true
    def extra_attributes
      object.extra_attributes.sort_by { |extra_attribute| extra_attribute['index'] }
    end

    field :created_by, String, null: true
    def created_by
      return nil if context[:current_user].nil?

      current_user_roles = context[:current_user]&.roles
      a_candidate_editor = current_user_roles.include?(User.user_roles[:candidate_editor])
      an_admin = current_user_roles.include?(User.user_roles[:admin])
      return nil if context[:current_user].id != object.created_by_id && !an_admin && !a_candidate_editor

      User.find_by(id: object.created_by_id)&.email
    end

    field :description, String, null: true
    field :candidate_status, CandidateStatusType, null: true

    field :not_assigned_category_indicators, [Types::CategoryIndicatorType], null: true
    field :candidate_product_category_indicators, [Types::CandidateProductCategoryIndicatorType], null: true

    field :overall_maturity_score, Float, null: true
    field :maturity_score_details, GraphQL::Types::JSON, null: true

    field :created_at, GraphQL::Types::ISO8601Date, null: true

    field :commercial_product, Boolean, null: false

    field :rejected, Boolean, null: true
    field :rejected_date, GraphQL::Types::ISO8601Date, null: true
    field :rejected_by, String, null: true

    field :approved_date, GraphQL::Types::ISO8601Date, null: true
    field :approved_by, String, null: true

    def rejected_by
      return nil if context[:current_user].nil?

      current_user_roles = context[:current_user]&.roles
      a_candidate_editor = current_user_roles&.include?(User.user_roles[:candidate_editor])
      an_admin = current_user_roles.include?(User.user_roles[:admin])
      return nil if context[:current_user].id != object.created_by_id && !an_admin && !a_candidate_editor

      User.find_by(id: object.rejected_by_id)&.email
    end

    def approved_by
      return nil if context[:current_user].nil?

      current_user_roles = context[:current_user]&.roles
      a_candidate_editor = current_user_roles&.include?(User.user_roles[:candidate_editor])
      an_admin = current_user_roles.include?(User.user_roles[:admin])
      return nil if context[:current_user].id != object.created_by_id && !an_admin && !a_candidate_editor

      User.find_by(id: object.approved_by_id)&.email
    end
  end
end
