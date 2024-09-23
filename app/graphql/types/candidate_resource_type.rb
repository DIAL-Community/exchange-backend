# frozen_string_literal: true

module Types
  class CandidateResourceType < Types::BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :description, String, null: false
    field :parsed_description, String, null: true
    def parsed_description
      first_paragraph = Nokogiri::HTML.fragment(object.description).at('p')
      return first_paragraph.text unless first_paragraph.nil?
      object.description if first_paragraph.nil?
    end

    field :resource_type, String, null: false
    field :resource_link, String, null: true
    field :link_description, String, null: false

    field :published_date, GraphQL::Types::ISO8601Date, null: true

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

    field :submitter_email, String, null: true
    def submitter_email
      unless context[:current_user].nil?
        object.submitter_email
      end
    end

    field :countries, [Types::CountryType], null: false, method: :countries_ordered
  end
end
