# frozen_string_literal: true

require 'modules/slugger'
include Modules::Slugger

module Modules
  # Task tracker utility functions.
  module Track
    def track_task(task_name, message, description)
      task_slug = slug_em(task_name)
      task_tracker = TaskTracker.find_by(slug: task_slug)
      if task_tracker.nil?
        task_tracker = TaskTracker.new
        task_tracker.name = task_name
        task_tracker.slug = task_slug
      end

      task_tracker.last_received_message = message
      task_tracker.last_started_date = Time.now
      if task_tracker.save
        puts "Task: '#{task_name}' recorded with message: '#{message}'."

        task_tracker_description = TaskTrackerDescription.find_by(
          task_tracker_id: task_tracker.id,
          locale: I18n.locale
        )
        if task_tracker_description.nil?
          description = "Task tracker for: #{task_name}." if description.nil? || description.blank?

          task_tracker_description = TaskTrackerDescription.new
          task_tracker_description.description = description
          task_tracker_description.task_tracker_id = task_tracker.id
          task_tracker_description.locale = I18n.locale
          task_tracker_description.save
        end
      end
    end

    def tracking_task_setup(task_name, message, description)
      track_task(task_name, message, description)
    end

    def tracking_task_start(task_name)
      track_task(task_name, 'Starting up task.')
    end

    def tracking_task_finish(task_name)
      track_task(task_name, 'Task completed.')
    end

    def tracking_task_exception(task_name, message)
      track_task(task_name, message)
    end
  end
end
