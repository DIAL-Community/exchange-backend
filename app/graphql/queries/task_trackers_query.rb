# frozen_string_literal: true

module Queries
  class TaskTrackersQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::TaskTrackerType], null: false

    def resolve(search:)
      return [] unless an_admin

      task_trackers = TaskTracker.order(:name)
      task_trackers = task_trackers.name_contains(search) unless search.blank?
      task_trackers
    end
  end

  class TaskTrackerQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::TaskTrackerType, null: true

    def resolve(slug:)
      return nil unless an_admin

      TaskTracker.find_by(slug:)
    end
  end
end
