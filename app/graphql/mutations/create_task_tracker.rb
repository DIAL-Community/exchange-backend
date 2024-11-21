# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateTaskTracker < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :description, String, required: true

    field :task_tracker, Types::TaskTrackerType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, description:)
      task_tracker = TaskTracker.find_by(slug:)
      if task_tracker.nil?
        task_tracker = TaskTracker.find_by(name:)
      end

      task_tracker_policy = Pundit.policy(context[:current_user], task_tracker || TaskTracker.new)
      if task_tracker.nil? && !task_tracker_policy.create_allowed?
        return {
          task_tracker: nil,
          errors: ['Creating / editing task tracker is not allowed.']
        }
      end

      if !task_tracker.nil? && !task_tracker_policy.edit_allowed?
        return {
          task_tracker: nil,
          errors: ['Creating / editing task tracker is not allowed.']
        }
      end

      # Prevent creating new task tracker. Only allow updating the description.
      if task_tracker.nil?
        return {
          task_tracker: nil,
          errors: ['Unable to find the expected task_tracker']
        }
      end
      assign_auditable_user(task_tracker)

      successful_operation = false
      ActiveRecord::Base.transaction do
        task_tracker.name = name
        task_tracker.save!

        task_tracker_description = TaskTrackerDescription.find_by(task_tracker_id: task_tracker.id, locale: I18n.locale)
        task_tracker_description = TaskTrackerDescription.new if task_tracker_description.nil?
        unless description.blank?
          task_tracker_description.description = description
          task_tracker_description.task_tracker_id = task_tracker.id
          task_tracker_description.locale = I18n.locale
        end
        assign_auditable_user(task_tracker_description)
        task_tracker_description.save!

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          task_tracker:,
          errors: []
        }
      else
        # Failed save, return the errors to the client.
        # We will only reach this block if the transaction is failed.
        {
          task_tracker: nil,
          errors: task_tracker.errors.full_messages
        }
      end
    end
  end
end
