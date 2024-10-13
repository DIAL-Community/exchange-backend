# frozen_string_literal: true

module Types
  class CandidateStatusType < Types::BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :description, String, null: false

    field :initial_status, Boolean, null: false
    field :terminal_status, Boolean, null: false

    field :notification_template, String, null: false

    field :next_candidate_statuses, [Types::CandidateStatusType], null: true
    field :previous_candidate_statuses, [Types::CandidateStatusType], null: true
  end
end
