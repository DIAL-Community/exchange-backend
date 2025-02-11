# frozen_string_literal: true

module Paginated
  class PaginationAttributeTaskTracker < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :show_failed_only, Boolean, required: false, default_value: false

    type Attributes::PaginationAttributes, null: false

    def resolve(search:, show_failed_only:)
      # Validate access to the current entity type.
      validate_access_to_resource(TaskTracker.new)

      task_trackers = TaskTracker.order(:name)
      unless search.blank?
        name_filter = task_trackers.name_contains(search)
        desc_filter = task_trackers.left_joins(:task_tracker_descriptions)
                                   .where('LOWER(task_tracker_descriptions.description) like LOWER(?)', "%#{search}%")
        task_trackers = task_trackers.where(id: (name_filter + desc_filter).uniq)
      end

      if show_failed_only
        task_trackers = task_trackers.where(task_completed: false)
      end

      { total_count: task_trackers.count }
    end
  end
end
