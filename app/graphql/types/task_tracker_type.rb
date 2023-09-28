# frozen_string_literal: true

module Types
  class TaskTrackerDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :task_tracker_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class TaskTrackerType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :task_completed, Boolean, null: false

    field :last_received_message, String, null: false
    field :last_started_date, GraphQL::Types::ISO8601Date, null: true

    field :task_tracker_descriptions, [Types::TaskTrackerDescriptionType], null: true
    field :task_tracker_description, Types::TaskTrackerDescriptionType, null: true, method: :description_localized
  end
end
