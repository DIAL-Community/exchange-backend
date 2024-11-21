# frozen_string_literal: true

module Queries
  class TaskTrackerQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::TaskTrackerType, null: true

    def resolve(slug:)
      task_tracker = TaskTracker.find_by(slug:) if valid_slug?(slug)
      validate_access_to_instance(task_tracker || TaskTracker.new)
      task_tracker
    end
  end

  class TaskTrackersQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::TaskTrackerType], null: false

    def resolve(search:)
      validate_access_to_resource(TaskTracker.new)
      task_trackers = TaskTracker.order(:name)
      task_trackers = task_trackers.name_contains(search) unless search.blank?
      task_trackers
    end
  end
end
