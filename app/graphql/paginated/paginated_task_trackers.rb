# frozen_string_literal: true

module Paginated
  class PaginatedTaskTrackers < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :show_failed_only, Boolean, required: false, default_value: false
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::TaskTrackerType], null: false

    def resolve(search:, show_failed_only:, offset_attributes:)
      # Validate access to the current entity type.
      validate_access_to_resource(TaskTracker.new)

      task_trackers = TaskTracker.order(last_started_date: :desc)
      unless search.blank?
        name_filter = task_trackers.name_contains(search)
        desc_filter = task_trackers.left_joins(:task_tracker_descriptions)
                                   .where('LOWER(task_tracker_descriptions.description) like LOWER(?)', "%#{search}%")
        task_trackers = task_trackers.where(id: (name_filter + desc_filter).uniq)
      end

      if show_failed_only
        task_trackers = task_trackers.where(task_completed: false)
      end

      offset_params = offset_attributes.to_h
      task_trackers.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
