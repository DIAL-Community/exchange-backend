# frozen_string_literal: true

require 'modules/slugger'
include Modules::Slugger

module Modules
  module Track
    def tracking_task_setup(task_name, message, description = nil)
      task_slug = slug_em(task_name)
      task_tracker = TaskTracker.find_by(slug: task_slug)
      if task_tracker.nil?
        task_tracker = TaskTracker.new
        task_tracker.name = task_name
        task_tracker.slug = task_slug
      end

      task_tracker.last_received_message = message
      if task_tracker.save
        puts "Task Tracker: #{task_name}, saving message: '#{message}'."

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

    def tracking_task_start(task_name)
      task_slug = slug_em(task_name)
      task_tracker = TaskTracker.find_by(slug: task_slug)
      return if task_tracker.nil?

      task_tracker.last_received_message = 'Starting up task.'
      task_tracker.last_started_date = Time.now
      task_tracker.task_completed = false
      task_tracker.save
    end

    def tracking_task_log(task_name, message)
      task_slug = slug_em(task_name)
      task_tracker = TaskTracker.find_by(slug: task_slug)
      return if task_tracker.nil?

      task_tracker.last_received_message = message
      task_tracker.save
    end

    def tracking_task_finish(task_name)
      task_slug = slug_em(task_name)
      task_tracker = TaskTracker.find_by(slug: task_slug)
      return if task_tracker.nil?

      task_tracker.last_received_message = 'Task completed.'
      task_tracker.task_completed = true

      task_tracker.save
    end
  end
end
